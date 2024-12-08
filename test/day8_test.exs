defmodule Day8Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(8, true)

    assert Day8.first(input) == 14
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(8, true)

    assert Day8.second(input) == 34
  end
end
