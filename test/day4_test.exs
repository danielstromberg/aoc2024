defmodule Day4Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(4, true)

    assert Day4.first(input) == 18
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(4, true)

    assert Day4.second(input) == 9
  end
end
