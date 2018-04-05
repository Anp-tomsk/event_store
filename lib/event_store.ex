defmodule EventStore do
  alias EventStore.Server

  def store(event), do:
    GenServer.cast(Server, {:store, event})

  def all(), do:
    GenServer.call(Server, :all)

  def view(design_name, name), do:
    GenServer.call(Server, {:view, design_name, name})

end
