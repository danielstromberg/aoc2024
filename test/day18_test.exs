defmodule Day18Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(18, true)

    assert Day18.first(input, {6, 6}, 12) == 22
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(18, true)

    assert Day18.second(input, {6, 6}) == "6,1"
  end
end
