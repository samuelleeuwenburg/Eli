defmodule ELI.Google do
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
      reply = get_query(msg) |> query
      ExIrc.Client.msg client, :privmsg, channel, reply
    end
    {:noreply, client}
  end

  def handle_info(_msg, client), do: {:noreply, client}

  def test(msg) do
    %{nick: nick} = Application.get_env(:eli, :bot)
    message = String.downcase msg
    regex = ~r/^@?#{nick}:? g(oogle)? (.+)$/

    Regex.match? regex, message
  end

  def get_query(msg) do
    %{nick: nick} = Application.get_env(:eli, :bot)
    message = String.downcase msg
    regex = ~r/^@?#{nick}:? g(oogle)? (?<query>.+)$/

    case Regex.named_captures regex, message do
      %{"query" => query} -> query
      _ -> false
    end
  end

  def query(query) do
    {:ok, "yolo", "and more"}

    HTTPoison.start
    url = "https://www.google.nl/search?q=#{query}"
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url)

    description = Floki.find(body, ".st") |> List.first |> Floki.text

    {_, _, children} = Floki.find(body, "cite") |> List.first
    url = List.foldl(children, "", fn (child, acc) ->
      case child do
        str when is_bitstring(str) -> acc <> str
        node when is_tuple(node) -> acc <> Floki.text(node)
        _ -> acc
      end
    end)

    "#{description} -> #{url}" |> String.replace(~r/\r|\n/, "")
  end
end