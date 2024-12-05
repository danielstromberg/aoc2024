defmodule Day5Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(5, true)

    assert Day5.first(input) == 143
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(5, true)

    assert Day5.second(input) == 123
  end
end
