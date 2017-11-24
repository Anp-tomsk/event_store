defmodule EventStore.Server do
  use GenServer

  alias EventStore.Couchdb.Database
  alias EventStore.Store

  @me __MODULE__

  def start_link(url, name), do:
    GenServer.start_link(@me, {url, name}, name: @me)

  def init({url, name}), do:
    Database.connect(url, name)

  def handle_cast({:store, event}, _from, database) do
    Store.store(database, event)
    {:noreply, database}
  end

  def handle_call(:all, _from, database), do:
    {:reply, database |> Store.all, database}

end
