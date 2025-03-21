defmodule FileSpyTest do
  use ExUnit.Case
  doctest FileSpy

  test "greets the world" do
    assert FileSpy.hello() == :world
  end
end
