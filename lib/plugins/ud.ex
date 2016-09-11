defmodule ELI.UD do
  require Logger

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, client}
  end

  def handle_info({:received, msg, _info, channel}, client) do
    if test(msg) do
      reply = get_query(msg) |> query
      ExIrc.Client.msg client, :privmsg, channel, reply
    end

    {:noreply, client}
  end

  def handle_info(_msg, client), do: {:noreply, client}

  def test(msg) do
    %{nick: nick} = Application.get_env(:eli, :bot)
    message = String.downcase msg
    regex = ~r/^@?#{nick}:? (.*[^\?])\?+$/

    Regex.match? regex, message
  end

  def get_query(msg) do
    %{nick: nick} = Application.get_env(:eli, :bot)
    message = String.downcase msg
    regex = ~r/^@?#{nick}:? (?<query>.*[^\?])\?+$/

    case Regex.named_captures regex, message do
      %{"query" => query} -> query
      _ -> false
    end
  end

  def query(query) do
    HTTPoison.start
    url = "http://www.urbandictionary.com/define.php?term=#{query}"
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url)

    [meaning_div | _] = Floki.find(body, ".meaning")
    [example_div | _] = Floki.find(body, ".example")
    {_, _, [meaning]} = meaning_div
    {_, _, [example]} = example_div

    String.replace "#{meaning} -> _#{example}_", ~r/\n/, ""
  end
end
