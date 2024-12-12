defmodule Day12 do

  def first(input) do
    input
    |> parse()
    |> plots()
    |> Enum.map(&calc_score/1)
    |> Enum.sum()
  end

  def second(input) do
    input
    |> parse()
    |> plots()
    |> Enum.map(&calc_score2/1)
    |> Enum.sum()
  end

  defp calc_score(set) do
    list = MapSet.to_list(set)
    area = length(list)

    perimeter =
      list
      |> Enum.map(&adjacent/1)
      |> Enum.map(fn adjacent -> 4 - Enum.count(adjacent, &MapSet.member?(set, &1)) end)
      |> Enum.sum()

    area * perimeter
  end

  defp calc_score2(set) do
    list = MapSet.to_list(set)
    area = length(list)

    perimeter =
      list
      |> Enum.map(&edges(&1, set))
      |> Enum.sum()

    area * perimeter
  end

  defp edges(pos, set) do
    adjacent_left = adjacent?(set, pos, :left)
    adjacent_right = adjacent?(set, pos, :right)
    adjacent_up = adjacent?(set, pos, :up)
    adjacent_down = adjacent?(set, pos, :down)
    adjacent_nw = adjacent?(set, pos, :nw)
    adjacent_sw = adjacent?(set, pos, :sw)
    adjacent_ne = adjacent?(set, pos, :ne)
    adjacent_se = adjacent?(set, pos, :se)
    direct_adj_len = Enum.count([adjacent_left, adjacent_right, adjacent_up, adjacent_down], &(&1))

    case direct_adj_len do
      0 ->
        4
      1 ->
        2
      2 when adjacent_left and adjacent_right or adjacent_up == adjacent_down ->
        0
      2 when adjacent_right and adjacent_down and adjacent_se ->
        1
      2 when adjacent_right and adjacent_up and adjacent_ne ->
        1
      2 when adjacent_left and adjacent_down and adjacent_sw ->
        1
      2 when adjacent_left and adjacent_up and adjacent_nw ->
        1
      2 ->
        2
      3 when adjacent_up and adjacent_down and adjacent_right ->
        2 - Enum.count([adjacent_se, adjacent_ne], &(&1))
      3 when adjacent_up and adjacent_down and adjacent_left ->
        2 - Enum.count([adjacent_sw, adjacent_nw], &(&1))
      3 when adjacent_left and adjacent_right and adjacent_up ->
        2 - Enum.count([adjacent_nw, adjacent_ne], &(&1))
      3 when adjacent_left and adjacent_right and adjacent_down ->
        2 - Enum.count([adjacent_sw, adjacent_se], &(&1))
      _ ->
        4 - Enum.count([adjacent_sw, adjacent_se, adjacent_nw, adjacent_ne], &(&1))
    end
  end

  defp adjacent({x, y}, :nw), do: {x - 1, y - 1}
  defp adjacent({x, y}, :sw), do: {x - 1, y + 1}
  defp adjacent({x, y}, :ne), do: {x + 1, y - 1}
  defp adjacent({x, y}, :se), do: {x + 1, y + 1}
  defp adjacent({x, y}, :up), do: {x, y - 1}
  defp adjacent({x, y}, :down), do: {x, y + 1}
  defp adjacent({x, y}, :left), do: {x - 1, y}
  defp adjacent({x, y}, :right), do: {x + 1, y}

  defp adjacent?(set, pos, dir), do: MapSet.member?(set, adjacent(pos, dir))

  defp adjacent({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

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
