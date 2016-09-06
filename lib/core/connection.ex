defmodule ELI.Connection do
  require Logger

  defmodule State do
    defstruct host: nil,
              port: nil,
              pass: nil,
              nick: nil,
              user: nil,
              name: nil,
              client: nil
  end

  def start_link(client, state \\ %State{}) do
    config = Application.get_env(:eli, :bot)
    state = Enum.reduce(config, %State{}, fn {k, v}, acc ->
      case Map.has_key?(acc, k) do
        true -> Map.put(acc, k, v)
        false -> acc
      end
    end)

    GenServer.start_link(__MODULE__, [%{state | client: client}])
  end

  def init([state]) do
    ExIrc.Client.add_handler state.client, self
    ExIrc.Client.connect! state.client, state.host, state.port
    {:ok, state}
  end

  def handle_info({:connected, server, port}, state) do
    Logger.info "Connected to #{server}:#{port}"
    ExIrc.Client.logon state.client, state.pass, state.nick, state.user, state.name
    {:noreply, state}
  end

  def handle_info(_msg, client), do: {:noreply, client}
end
