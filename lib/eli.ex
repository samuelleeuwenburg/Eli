defmodule ELI do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, client} = ExIrc.start_client!

    children = [
      worker(ELI.Connection, [client]),
      worker(ELI.Login, [client]),
      worker(ELI.Ohai, [client]),
    ]

    opts = [strategy: :one_for_one, name: ELI.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
