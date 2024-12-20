defmodule Day20 do
  def first(input, min_save_time \\ 100), do: solve(input, 2, min_save_time)
  def second(input, min_save_time \\ 100), do: solve(input, 20, min_save_time)

  defp solve(input, cheat_time, min_save_time) do
    %{walls: walls, start: start, goal: goal} = parse(input)

    path = find_path(walls, start, [goal])
    pwi = Enum.with_index(path)

    pwi
    |> Enum.map(fn {{x1, y1}, idx1} ->
      pwi
      |> Enum.slice(idx1 + min_save_time + 2..-1//1)
      |> Enum.count(fn {{x2, y2}, idx2} ->
        limit = min(idx2 - idx1 - min_save_time, cheat_time)

        abs(x2 - x1) + abs(y2 - y1) <= limit
      end)
    end)
    |> Enum.sum()
  end

  defp find_path(_walls, goal, [goal | _] = path), do: path
  defp find_path(walls, goal, [pos | _] = path) do
    prev = Enum.at(path, 1)

    pos
    |> adjacent()
    |> List.delete(prev)
    |> Enum.find(&!MapSet.member?(walls, &1))
    |> then(&(find_path(walls, goal, [&1 | path])))
  end

  defp adjacent({x, y}), do: [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]

  defp parse(input) do
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

    start = Enum.find_value(map, fn {x, y, "S"} -> {x, y}; _ -> false end)
    goal = Enum.find_value(map, fn {x, y, "E"} -> {x, y}; _ -> false end)

    walls =
      map
      |> Enum.filter(fn {_x, _y, c} -> c == "#" end)
      |> Enum.into(MapSet.new(), fn {x, y, _c} -> {x, y} end)

    %{walls: walls, start: start, goal: goal}
  end
end
