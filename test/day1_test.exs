defmodule Day1Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(1, true)

    assert Day1.first(input) == 11
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(1, true)

    assert Day1.second(input) == 31
  end
end
