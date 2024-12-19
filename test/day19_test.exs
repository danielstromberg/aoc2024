defmodule Day19Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(19, true)

    assert Day19.first(input) == 6
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(19, true)

    assert Day19.second(input) == 16
  end
end
