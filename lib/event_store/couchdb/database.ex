defmodule EventStore.Couchdb.Database do

  def connect(url, name), do: connect(url, name, [])

  def connect(url, name, opts) when is_bitstring(url) and is_atom(name), do:
    connect(url, Atom.to_string(name), opts)

  def connect(url, name, opts)  when is_bitstring(url) and is_bitstring(name) do
    server = :couchbeam.server_connection(url, opts)
    {:ok, _version} = :couchbeam.server_info(server)
    init_database(server, name, :couchbeam.db_exists(server, name))
  end

  def init_database(server, name, _db_exists=true), do:
    :couchbeam.open_db(server, name)

  def init_database(server, name, _db_exists), do:
    :couchbeam.create_db(server, name)

end
