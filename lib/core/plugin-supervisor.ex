defmodule ELI.PluginSupervisor do
	use Supervisor

  def start_link(client) do
    {:ok, pid} = Supervisor.start_link(__MODULE__, client)
  end

  def init(client) do
    children = [
      worker(ELI.Ohai, [client]),
      worker(ELI.UD, [client])
    ]
    supervise children, strategy: :one_for_one
  end
end
