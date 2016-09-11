defmodule ELITest.Ohai do
  use ExUnit.Case
  doctest ELI.Ohai

  test "Ohai listens for mentions" do
    %{nick: nick} = Application.get_env(:eli, :bot)

    assert ELI.Ohai.test("hi #{nick}") == true
    assert ELI.Ohai.test("hi @#{nick}") == true
    assert ELI.Ohai.test("#{nick}: hi") == true
    assert ELI.Ohai.test("hello #{nick}") == true
    assert ELI.Ohai.test("@#{nick}: hello") == true
    assert ELI.Ohai.test("hey #{nick}") == true

    assert ELI.Ohai.test("hello bar#{nick}foo") == false
    assert ELI.Ohai.test("bar#{nick}foo: hey") == false
  end

  test "Ohai says hello back to the given nickname" do
    assert ELI.Ohai.reply("foo") == "hello foo"
    assert ELI.Ohai.reply("foo") != "hello fool"
  end
end
