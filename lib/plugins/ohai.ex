defmodule ELI.Ohai do
  require Logger

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, client}
  end

  def handle_info({:received, msg, info, channel}, client) do
    if test(msg) do
      %{ nick: nick } = info
      ExIrc.Client.msg client, :privmsg, channel, reply(nick)
    end

    {:noreply, client}
  end

  def handle_info(_msg, client), do: {:noreply, client}

  def test(msg) do
    %{nick: nick} = Application.get_env(:eli, :bot)
    message = String.downcase msg
    regex = ~r/@?#{nick}:?/

    unless Regex.match?(regex, message), do: false

    message = String.replace message, regex, ""

    case String.strip message do
      "hi" -> true
      "hello" -> true
      "hey" -> true
      _ -> false
    end
  end

  def reply(nick), do: "hello #{nick}"
end
