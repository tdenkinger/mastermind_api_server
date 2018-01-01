defmodule CreateCodeTest do
  use ExUnit.Case
  doctest Mastermind.CreateCode

  alias Mastermind.CreateCode

  test "creates a code" do
    code = CreateCode.new(4)
    assert Enum.count(code) == 4
  end
end
