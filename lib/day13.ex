defmodule Day13 do
  def first(input) do
    input
    |> parse()
    |> Enum.map(&calc_cost/1)
    |> Enum.sum()
  end

  def second(input) do
    input
    |> parse()
    |> Enum.map(&calc_giga_cost/1)
    |> Enum.sum()
  end

  defp calc_giga_cost([{x1, x2, x3}, {y1, y2, y3}]), do: calc_cost([{x1, x2, 10000000000000 + x3}, {y1, y2, 10000000000000 + y3}])

  defp calc_cost([{x1, x2, x3}, {y1, y2, y3}]) do
    a = (x3 * y2 - x2 * y3) / (x1 * y2 - x2 * y1)
    b = (x3 * y1 - x1 * y3) / (x2 * y1 - x1 * y2)

    if a - trunc(a) == 0 and b - trunc(b) == 0 do
      trunc(a) * 3 + trunc(b)
    else
      0
    end
  end

  defp parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_machine/1)
  end

  defp parse_machine(string) do
    Regex.scan(~r/\d+/, string)
    |> Enum.map(&hd/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.zip()
  end
end
