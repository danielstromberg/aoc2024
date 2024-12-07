defmodule Day7Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(7, true)

    assert Day7.first(input) == 3749
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(7, true)

    assert Day7.second(input) == 11387
  end
end
