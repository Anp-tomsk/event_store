defmodule EventStore.Server do
  use GenServer

  alias EventStore.Couchdb.Database
  alias EventStore.Store

  @me __MODULE__

  def start_link(url, name), do:
    GenServer.start_link(@me, {url, name}, name: @me)

  def init({url, name}), do:
    Database.connect(url, name)

  def handle_cast({:store, event}, database) do
    Store.store(database, event)
    |> handle_stored()
    {:noreply, database}
  end

  def handle_call(:all, _from, database), do:
    {:reply, database |> Store.all, database}

  def handle_call({:view, design_name, name}, _from, database), do:
    {:reply, Store.view(database, design_name, name), database}

  defp handle_stored({:error, reason}),
    do: IO.puts("An error occured for the following reason #{reason}")

  defp handle_stored(_doc),
    do: IO.puts("Succesfully stored document")

end
