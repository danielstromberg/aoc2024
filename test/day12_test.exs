defmodule Day12Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(12, true)

    assert Day12.first(input) == 1930
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(12, true)

    assert Day12.second(input) == 1206
  end
end
