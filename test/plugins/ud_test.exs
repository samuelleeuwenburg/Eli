defmodule ELITest.UD do
  use ExUnit.Case
  doctest ELI.UD

  test "UD plugin listens to query commands" do
    %{nick: nick} = Application.get_env(:eli, :bot)

    assert ELI.UD.test("#{nick} test?") == true
    assert ELI.UD.test("#{nick}: test?") == true
    assert ELI.UD.test("@#{nick} googly moogly?") == true

    assert ELI.UD.test("#{nick} test") == false
    assert ELI.UD.test("foobar #{nick} ud test") == false
  end

  test "UD plugin gets query from message" do
    %{nick: nick} = Application.get_env(:eli, :bot)

    assert ELI.UD.get_query("#{nick}: test?") == "test"
    assert ELI.UD.get_query("#{nick} googly moogly?") == "googly moogly"

    assert ELI.UD.get_query("#{nick}: gooogle test") == false
    assert ELI.UD.get_query("urban test") == false
  end

  test "UD plugin replies to queries with urban results" do
    assert ELI.UD.query("test") ==
      "A process for testing things -> _This is a test message_"

    assert ELI.UD.query("pineapples") ==
      "what the fuck are you looking at the definition of pineapples for you stupid fuck? " <>
      "-> _you should know what pineapples are._"
  end
end
