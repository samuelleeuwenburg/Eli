defmodule ELITest.Google do
  use ExUnit.Case
  doctest ELI.Google

  test "Google listens for query commands" do
    %{nick: nick} = Application.get_env(:eli, :bot)

    assert ELI.Google.test("#{nick} google test") == true
    assert ELI.Google.test("#{nick} g test") == true
    assert ELI.Google.test("#{nick} g test foo bar") == true

    assert ELI.Google.test("#{nick} foo bar google") == false
    assert ELI.Google.test("#{nick} foo google bar") == false
  end

  test "Google gets query from message" do
    %{nick: nick} = Application.get_env(:eli, :bot)

    assert ELI.Google.get_query("#{nick} google test") == "test"
    assert ELI.Google.get_query("#{nick} google foo bar") == "foo bar"
    assert ELI.Google.get_query("#{nick} g bar foo") == "bar foo"
    assert ELI.Google.get_query("#{nick} g bar!!foo∆") == "bar!!foo∆"

    assert ELI.Google.get_query("#{nick} ∆bar!!foo∆") == false
    assert ELI.Google.get_query("#{nick}ss google test") == false
  end

  test "Google fetches google results" do
    assert ELI.Google.query("xkcd") ==
     "Stick-figure strip featuring humour about technology, " <>
     "science, mathematics and relationships, by Randall Munroe. -> xkcd.com/"
  end
end
