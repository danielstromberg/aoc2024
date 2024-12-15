defmodule Day15 do
  def first(input) do
    {initial_state, movements} = parse(input, 1)

    movements
    |> Enum.reduce(initial_state, &simulate/2)
    |> Map.get(:boxes)
    |> Enum.reduce(0, fn {x, y}, acc -> acc + x + y * 100 end)
  end

  def second(input) do
    {initial_state, movements} = parse(input, 2)

    movements
    |> Enum.reduce(initial_state, &simulate_scaled/2)
    |> Map.get(:boxes)
    |> Enum.reduce(0, fn {x, y}, acc -> acc + x + y * 100 end)
  end

  defp simulate(direction, state = %{obstacles: obstacles, boxes: boxes, pos: pos}) do
    new_pos = move(pos, direction)

    cond do
      MapSet.member?(obstacles, new_pos) ->
        state
      !MapSet.member?(boxes, new_pos) ->
        Map.replace!(state, :pos, new_pos)
      true ->
        spot = next_available_spot(direction, new_pos, obstacles, boxes)

        if spot do
          boxes
          |> MapSet.delete(new_pos)
          |> MapSet.put(spot)
          |> then(&Map.replace!(state, :boxes, &1))
          |> Map.replace!(:pos, new_pos)
        else
          state
        end
    end
  end

  defp next_available_spot(direction, pos, obstacles, boxes) do
    new_pos = move(pos, direction)

    cond do
      MapSet.member?(obstacles, new_pos) ->
        nil
      MapSet.member?(boxes, new_pos) ->
        next_available_spot(direction, new_pos, obstacles, boxes)
      true ->
        new_pos
    end
  end

  defp simulate_scaled(direction, state = %{obstacles: obstacles, boxes: boxes, pos: pos}) do
    new_pos = move(pos, direction)
    obstructing_boxes = obstructions(boxes, new_pos, -1..0)

    cond do
      obstructed?(obstacles, new_pos, -1..0) ->
        state
      Enum.count(obstructing_boxes) == 0 ->
        Map.replace!(state, :pos, new_pos)
      true ->
        box = hd(obstructing_boxes)

        with {:ok, pushed_boxes} <- push(direction, box, obstacles, boxes) do
          {old_positions, new_positions} = Enum.unzip(pushed_boxes)

          boxes
          |> MapSet.difference(MapSet.new(old_positions))
          |> MapSet.union(MapSet.new(new_positions))
          |> then(&Map.replace!(state, :boxes, &1))
          |> Map.replace!(:pos, new_pos)
        else
          _ -> state
        end
    end
  end

  defp push(direction, pos, obstacles, boxes) do
    new_pos = move(pos, direction)
    range = obstruction_range(direction)
    obstructing_boxes = obstructions(boxes, new_pos, range)

    cond do
      obstructed?(obstacles, new_pos, range) ->
        :obstructed
      Enum.count(obstructing_boxes) == 0 ->
        {:ok, [{pos, new_pos}]}
      true ->
        push_result = Enum.map(obstructing_boxes, &push(direction, &1, obstacles, boxes))

        if Enum.any?(push_result, &(&1 == :obstructed)) do
          :obstructed
        else
          pushed_boxes = Enum.flat_map(push_result, &elem(&1, 1))

          {:ok, [{pos, new_pos} | pushed_boxes]}
        end
    end
  end

  defp obstructed?(set, pos, offsets) do
    set
    |> obstructions(pos, offsets)
    |> Enum.any?()
  end

  defp obstructions(set, {x, y}, offsets) do
    offsets
    |> Enum.map(&({x + &1, y}))
    |> Enum.filter(&MapSet.member?(set, &1))
  end

  defp obstruction_range(:left), do: -1..-1
  defp obstruction_range(:right), do: 1..1
  defp obstruction_range(_), do: -1..1

  defp move({x, y}, :up), do: {x, y - 1}
  defp move({x, y}, :down), do: {x, y + 1}
  defp move({x, y}, :left), do: {x - 1, y}
  defp move({x, y}, :right), do: {x + 1, y}

  defp parse(input, width_scale) do
    [map_string, movements_string] = String.split(input, "\n\n")

    map =
      map_string
      |> String.split()
      |> Enum.map(&String.graphemes/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {r, y} ->
        r
        |> Enum.with_index()
        |> Enum.map(fn {c, x} -> {x * width_scale, y, c} end)
      end)

    start = Enum.find_value(map, fn {x, y, "@"} -> {x, y}; _ -> false end)

    obstacles =
      map
      |> Enum.filter(fn {_x, _y, c} -> c == "#" end)
      |> Enum.into(MapSet.new(), fn {x, y, _c} -> {x, y} end)

    boxes =
      map
      |> Enum.filter(fn {_x, _y, c} -> c == "O" end)
      |> Enum.into(MapSet.new(), fn {x, y, _c} -> {x, y} end)

    movements =
      movements_string
      |> String.replace("\n", "")
      |> String.graphemes()
      |> Enum.map(&parse_direction/1)

    {%{obstacles: obstacles, boxes: boxes, pos: start}, movements}
  end

  defp parse_direction("<"), do: :left
  defp parse_direction(">"), do: :right
  defp parse_direction("^"), do: :up
  defp parse_direction("v"), do: :down
end
