defmodule Day14 do
  def first(input, width \\ 101, height \\ 103) do
    mid_x = div(width, 2)
    mid_y = div(height, 2)

    input
    |> parse()
    |> Enum.map(&simulate(&1, 100, width, height))
    |> Enum.reject(fn {x, y} -> x == mid_x or y == mid_y end)
    |> Enum.group_by(fn {x, y} -> {x < mid_x, y < mid_y} end)
    |> Enum.map(&length(elem(&1, 1)))
    |> Enum.reduce(1, &*/2)
  end

  def second(input) do
    input
    |> parse()
    |> find_tree()
  end

  defp simulate({{x, y}, {_vx, _vy}}, 0, _, _), do: {x, y}
  defp simulate({{x, y}, {vx, vy}}, count, w, h) do
    simulate({{Integer.mod(x + vx, w), Integer.mod(y + vy, h)}, {vx, vy}}, count - 1, w, h)
  end

  defp find_tree(robots, elapsed \\ 1) do
    updated_robots = Enum.map(robots, fn x -> {simulate(x, 1, 101, 103), elem(x, 1)} end)

    set =
      updated_robots
      |> Enum.map(&elem(&1, 0))
      |> Enum.into(MapSet.new())

    if Enum.count(set, &has_adjacent_robot?(&1, set)) >= 250 do
      elapsed
    else
      find_tree(updated_robots, elapsed + 1)
    end
  end

  defp has_adjacent_robot?({x, y}, set), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}] |> Enum.any?(&MapSet.member?(set, &1))

  defp parse(input) do
    ~r/-?\d+/
    |> Regex.scan(input)
    |> Enum.map(&hd/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.map(fn [px, py, vx, vy] -> {{px, py}, {vx, vy}} end)
  end
end
