defmodule Day20Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(20, true)

    assert Day20.first(input, 10) == 10
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(20, true)

    assert Day20.second(input, 50) == 285
  end
end
