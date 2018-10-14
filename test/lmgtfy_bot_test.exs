defmodule LmgtfyBotTest do
  use ExUnit.Case
  doctest LmgtfyBot

  test "greets the world" do
    assert LmgtfyBot.hello() == :world
  end
end
