defmodule Day13Test do
  use ExUnit.Case

  test "solves first part of the puzzle with sample input" do
    input = InputReader.read(13, true)

    assert Day13.first(input) == 480
  end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(13, true)

    assert Day13.second(input) == 875318608908
  end
end
