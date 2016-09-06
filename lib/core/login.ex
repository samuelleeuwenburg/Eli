defmodule ELI.Login do
  require Logger

  def start_link(client) do
    {:ok, channels} = Application.get_env(:eli, :bot) |> Map.fetch(:channel)
    GenServer.start_link(__MODULE__, [client, channels])
  end

  def init([client, channels]) do
    ExIrc.Client.add_handler client, self
    {:ok, {client, channels}}
  end

  def handle_info(:logged_in, state = {client, channels}) do
    Logger.info "Logged in to server"
    channels |> Enum.map(&ExIrc.Client.join client, &1)
    {:noreply, state}
  end

  def handle_info(_msg, client), do: {:noreply, client}
end
