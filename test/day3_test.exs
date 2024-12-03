defmodule Day3Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(3, true)

    assert Day3.first(input) == 161
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(3, true)

    assert Day3.second(input) == 48
  end
end
