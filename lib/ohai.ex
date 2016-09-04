defmodule ELI.Ohai do
  require Logger

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, client}
  end

  def handle_info({:received, msg, nick, channel}, client) do
    Logger.info "received -> #{msg}"

    if String.contains?(msg, "hi") do
      ExIrc.Client.msg client, :privmsg, channel, "hi"
    end

    {:noreply, client}
  end

  def handle_info(_msg, client), do: {:noreply, client}
end
