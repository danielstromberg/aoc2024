defmodule Day15Test do
  use ExUnit.Case

  # test "solves first part of the puzzle with sample input" do
  #   input = InputReader.read(15, true)

  #   assert Day15.first(input) == 10092
  # end

  test "solves second part of the puzzle with sample input" do
    input = InputReader.read(15, true)

    assert Day15.second(input) == 9021
  end
end
