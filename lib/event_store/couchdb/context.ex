defmodule EventStore.Couchdb.Context do
  alias EventStore.Couchdb.Packet

  def write_doc(database, doc) when is_map(doc), do:
    write_doc(database, Packet.to_couch(doc))
  def write_doc(database, doc) when is_tuple(doc), do:
    write_doc(database, doc, Packet.valid_structure?(doc))

  def write_doc(database, doc, _valid=true) do
    :couchbeam.save_doc(database, doc)
    |> handle_response()
  end
  def write_doc(_database, _doc, _valid), do: {:error, "Invalid document structure"}

  def get_view(database, design_name, name) do
    :couchbeam_view.fetch(database, {design_name, name})
    |> fn {:ok, documents} ->
      {:ok,  Packet.unpack!(documents)}
    end.()
  end

  def get_all(database) do
    :couchbeam_view.all(database, [:include_docs])
    |> fn {:ok, documents} ->
      {:ok,  Packet.unpack!(documents)}
    end.()
  end

  def open_doc(database, id) do
    :couchbeam.open_doc(database, id)
    |> handle_response()
  end

  def handle_response({:ok, doc}), do: Packet.unpack(doc)

  def handle_response({:error, :conflict}), do: {:error, "Document with given id already exists"}
  def handle_response({:error, :not_found}), do: {:error, "Database does't exists use :couchbeam.create_db"}

end
