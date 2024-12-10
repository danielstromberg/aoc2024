defmodule Day10Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(10, true)

    assert Day10.first(input) == 36
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(10, true)

    assert Day10.second(input) == 81
  end
end
