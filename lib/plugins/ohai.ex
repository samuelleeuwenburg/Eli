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

  @doc """
    ## Examples
      iex> ELI.Ohai.test "Hi Eli"
      true
      iex> ELI.Ohai.test "foo Eli"
      false
  """
  def test(msg) do
    case String.downcase msg do
      "hi eli" -> true
      "hello eli" -> true
      _ -> false
    end
  end

  @doc """
    ## Examples
      iex> ELI.Ohai.reply "foo"
      "hello foo"
  """
  def reply(nick), do: "hello #{nick}"
end
