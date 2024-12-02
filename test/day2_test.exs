defmodule Day2Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(2, true)

    assert Day2.first(input) == 2
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(2, true)

    assert Day2.second(input) == 4
  end
end
