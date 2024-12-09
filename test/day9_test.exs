defmodule Day9Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(9, true)

    assert Day9.first(input) == 1928
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(9, true)

    assert Day9.second(input) == 2858
  end
end
