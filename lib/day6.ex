defmodule Day6 do
  def first(input) do
    input
    |> parse()
    |> simulate()
    |> length()
  end

  def second(input) do
    %{position: start} = state = parse(input)

    state
    |> simulate()
    |> Enum.reject(&(&1 == start))
    |> Enum.map(fn pos -> Map.update!(state, :obstacles, &MapSet.put(&1, pos)) end)
    |> Enum.map(&Task.async(fn -> simulate(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.count(&(&1 == :stuck_in_loop))
  end

  defp simulate(%{width: w, height: h, position: {x, y}, path: path}) when x < 0 or y < 0 or x >= w or y >= h do
    path
    |> MapSet.to_list()
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Enum.uniq()
  end
  defp simulate(state = %{position: {x, y}, path: path, obstacles: obstacles, direction: direction}) do
    new_state = Map.update!(state, :path, &MapSet.put(&1, {x, y, direction}))
    new_position = step({x, y}, direction)

    cond do
      MapSet.member?(path, {x, y, direction}) ->
        :stuck_in_loop
      MapSet.member?(obstacles, new_position) ->
        new_state
        |> Map.update!(:direction, &rem(&1 + 1, 4))
        |> simulate()
      true ->
        new_state
        |> Map.replace!(:position, new_position)
        |> simulate()
    end
  end

  defp step({x, y}, 0), do: {x, y - 1}
  defp step({x, y}, 1), do: {x + 1, y}
  defp step({x, y}, 2), do: {x, y + 1}
  defp step({x, y}, 3), do: {x - 1, y}

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

    start = Enum.find_value(map, fn {x, y, "^"} -> {x, y}; _ -> false end)

    obstacles =
      map
      |> Enum.filter(fn {_x, _y, c} -> c == "#" end)
      |> Enum.into(MapSet.new(), fn {x, y, _c} -> {x, y} end)

    %{width: w, height: h, obstacles: obstacles, path: MapSet.new(), position: start, direction: 0}
  end
end
