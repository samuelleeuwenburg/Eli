defmodule ELI do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, client} = ExIrc.start_client!

    children = [
      worker(ELI.Connection, [client]),
      worker(ELI.Login, [client, ["#elibot"]]),
      worker(ELI.Ohai, [client]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ELI.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
