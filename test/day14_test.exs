defmodule Day14Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(14, true)

    assert Day14.first(input, 11, 7) == 12
  end
end
