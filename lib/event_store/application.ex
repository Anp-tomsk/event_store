defmodule EventStore.Application do
  use Application
  alias EventStore.Server

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Server, ["http://localhost:5984", :store])
    ]

    opts = [strategy: :one_for_one, name: StoreSupervisor]

    {:ok, _pid} = Supervisor.start_link(children, opts)
  end

end
