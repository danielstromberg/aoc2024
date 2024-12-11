defmodule Day11Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(11, true)

    assert Day11.first(input) == 55312
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(11, true)

    assert Day11.second(input) == 65601038650482
  end
end
