defmodule Day1 do
  def first(input) do
    input
    |> parse()
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip_reduce(0, fn [a, b], acc -> acc + abs(a - b) end)
  end

  def second(input) do
    [left, right] = parse(input)

    left
    |> Enum.map(fn n -> n * Enum.count(right, &(&1 == n)) end)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.zip_with(&(&1))
  end
end
