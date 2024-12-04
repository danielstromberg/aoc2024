defmodule Day4 do
  def first(input) do
    input
    |> parse()
    |> solve(&words_at/3)
  end

  def second(input) do
    input
    |> parse()
    |> solve(&crosses_at/3)
  end

  defp solve(map, match_fun) do
    map
    |> Map.keys()
    |> Enum.reduce(0, fn {x, y}, acc -> acc + match_fun.(map, x, y) end)
  end

  defp words_at(map, x, y) do
    0..3
    |> Enum.map(fn o ->
      [
        map[{x + o, y}],
        map[{x, y + o}],
        map[{x + o, y + o}],
        map[{x - o, y + o}],
      ] end)
    |> Enum.zip_with(&(&1))
    |> Enum.map(&Enum.join/1)
    |> Enum.count(&(&1 == "XMAS" or &1 == "SAMX"))
  end

  defp crosses_at(map, x, y) do
    diag1 =
      [
        map[{x - 1, y - 1}],
        map[{x, y}],
        map[{x + 1, y + 1}],
      ]

    diag2 =
      [
        map[{x + 1, y - 1}],
        map[{x, y}],
        map[{x - 1, y + 1}],
      ]

    match =
      [diag1, diag2]
      |> Enum.map(&Enum.join/1)
      |> Enum.all?(&(&1 == "MAS" or &1 == "SAM"))

    if match, do: 1, else: 0
  end

  defp parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {r, y} ->
      r
      |> Enum.with_index()
      |> Enum.map(fn {c, x} -> %{{x, y} => c} end)
    end)
    |> Enum.reduce(%{}, &Map.merge/2)
  end
end
