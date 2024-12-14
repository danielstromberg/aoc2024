defmodule Day12 do
  def first(input), do: solve(input, &perimeter/2)
  def second(input), do: solve(input, &edges/2)

  defp solve(input, fun) do
    input
    |> parse()
    |> plots()
    |> Enum.map(fn plot -> calc_score(plot, fun) end)
    |> Enum.sum()
  end

  defp calc_score(set, fun) do
    list = MapSet.to_list(set)
    area = length(list)

    factor =
      list
      |> Enum.map(&fun.(&1, set))
      |> Enum.sum()

    area * factor
  end

  defp perimeter(pos, set), do: 4 - length(adjacent(pos, set))

  defp edges(pos, set) do
    adjacent = adjacent(pos, set)

    case length(adjacent) do
      0 ->
        4
      1 ->
        2
      2 ->
        [{x1, y1}, {x2, y2}] = adjacent

        if x1 == x2 or y1 == y2 do
          0
        else
          2 - inner_edges_count(pos, set)
        end
      3 ->
        2 - inner_edges_count(pos, set)
      _ ->
        4 - inner_edges_count(pos, set)
    end
  end

  defp inner_edges_count(pos, set) do
    pos
    |> adjacent(set)
    |> Enum.flat_map(&adjacent(&1, set))
    |> Enum.reject(&(&1 == pos))
    |> Enum.frequencies()
    |> Enum.count(&elem(&1, 1) == 2)
  end

  defp adjacent({x, y}, set), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}] |> Enum.filter(&MapSet.member?(set, &1))

  defp plots(list) do
    list
    |> Enum.zip_with(& &1)
    |> chunk()
    |> Kernel.++(chunk(list))
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1) |> MapSet.new())
    |> Map.values()
    |> Enum.flat_map(&merge/1)
  end

  defp merge(sets) do
    count = length(sets)

    merged =
      Enum.reduce(sets, [], fn set, acc ->
        index = Enum.find_index(acc, fn x -> !MapSet.disjoint?(x, set) end)

        if index == nil do
          [set | acc]
        else
          new_set = MapSet.union(Enum.at(acc, index), set)
          List.replace_at(acc, index, new_set)
        end
      end)

    if length(merged) == count do
      merged
    else
      merge(merged)
    end
  end

  defp chunk(list) do
    list
    |> Enum.map(fn x -> Enum.chunk_by(x, &elem(&1, 0)) end)
    |> Enum.flat_map(&chunk_row/1)
  end

  defp chunk_row(list) do
    Enum.map(list, fn c -> {c |> hd |> elem(0), Enum.map(c, fn {_, x, y} -> {x, y} end)} end)
  end

  defp parse(input) do
    input
    |> String.split()
    |> Enum.with_index()
    |> Enum.map(fn {row, index} -> {String.graphemes(row), index} end)
    |> Enum.map(fn {l, y} -> l |> Enum.with_index() |> Enum.map(fn {c, x} -> {c, x, y} end) end)
  end
end
