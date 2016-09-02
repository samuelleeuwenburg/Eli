defmodule ELI.Ohai do
  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, client}
  end

  def handle_info({:received, msg, nick, channel}, client) do
    debug "received:"
    IO.inspect msg

    if String.contains?(msg, "hi") do
      ExIrc.Client.msg client, :privmsg, channel, "hi"
    end

    {:noreply, client}
  end

  def handle_info(msg, client) do
    debug "unknown:"
    IO.inspect msg
    {:noreply, client}
  end

  defp debug(msg) do
    IO.puts IO.ANSI.yellow() <> msg <> IO.ANSI.reset()
  end
end
