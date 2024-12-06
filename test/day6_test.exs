defmodule Day6Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(6, true)

    assert Day6.first(input) == 41
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(6, true)

    assert Day6.second(input) == 6
  end
end
