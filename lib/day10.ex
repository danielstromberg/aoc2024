defmodule Day10 do
  def first(input) do
    input
    |> parse()
    |> solve(&Enum.uniq/1)
  end

  def second(input) do
    input
    |> parse()
    |> solve()
  end

  defp solve(map, fun \\ &(&1)) do
    map
    |> Enum.filter(fn {_, height} -> height == 0 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&calc_paths(&1, map))
    |> Enum.map(&(fun.(&1)))
    |> Enum.map(&length/1)
    |> Enum.sum()
  end

  defp calc_paths(pos, map) do
    height = map[pos]

    case height do
      9 -> [pos]
      _ ->
        pos
        |> adjacent()
        |> Enum.filter(fn p -> map[p] == height + 1 end)
        |> Enum.reduce([], fn p, acc -> calc_paths(p, map) ++ acc end)
    end
  end

  defp adjacent({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

  defp parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {r, y} ->
      r
      |> Enum.with_index()
      |> Enum.map(fn {height, x} -> %{{x, y} => String.to_integer(height)} end)
    end)
    |> Enum.reduce(%{}, &Map.merge/2)
  end
end
