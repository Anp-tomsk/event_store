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

end
