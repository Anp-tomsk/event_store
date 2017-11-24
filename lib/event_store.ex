defmodule EventStore do
  alias EventStore.Server

  def store(event), do:
    GenServer.cast(Server, {:store, event})

  def all(), do:
    GenServer.call(Server, :all)

end
