defmodule Day8 do
  def first(input) do
    input
    |> parse()
    |> solve([1])
  end

  def second(input) do
    map = %{width: w, height: h} = parse(input)
    n = min(w, h)

    solve(map, 0..n)
  end

  defp solve(%{width: w, height: h, antennas: antennas}, offsets) do
    antennas
    |> Enum.group_by(&(elem(&1, 2)), fn {x, y, _} -> {x, y} end)
    |> Map.values()
    |> Enum.flat_map(&(calc_antinodes(&1, offsets)))
    |> Enum.filter(fn {x, y} -> x >= 0 and x < w and y >= 0 and y < h end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp calc_antinodes(coords, offsets) do
    for p1 <- coords, p2 <- coords, p1 != p2, reduce: [] do
      acc -> calc_antinodes(p1, p2, offsets) ++ acc
    end
  end

  defp calc_antinodes({x1, y1}, {x2, y2}, offsets) do
    dx = x2 - x1
    dy = y2 - y1

    Enum.map(offsets, fn n -> {x2 + n * dx, y2 + n * dy} end)
  end

  defp parse(input) do
    lines = String.split(input)

    w = lines |> Enum.at(0) |> String.length()
    h = length(lines)

    map =
      input
      |> String.split()
      |> Enum.map(&String.graphemes/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {r, y} ->
        r
        |> Enum.with_index()
        |> Enum.map(fn {c, x} -> {x, y, c} end)
      end)
      |> Enum.filter(fn {_x, _y, c} -> c != "." end)

    %{width: w, height: h, antennas: map}
  end
end
