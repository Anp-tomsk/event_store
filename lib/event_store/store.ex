defmodule EventStore.Store do
  alias EventStore.Couchdb.{Context}

  def store(database, event) do
    database
    |> Context.write_doc(event)
  end

  def all(database) do
    database
    |> Context.get_all()
  end

  def view(database, design_name, name),
    do: Context.get_view(database, design_name, name)

end
