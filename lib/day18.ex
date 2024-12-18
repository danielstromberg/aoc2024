defmodule Day18 do
  def first(input, goal \\ {70, 70}, limit \\ 1024) do
    queue = :queue.from_list([[{0, 0}]])
    obstacles =
      input
      |> parse()
      |> Enum.take(limit)
      |> Enum.into(MapSet.new(), &List.to_tuple/1)

    bfs(queue, goal, obstacles)
  end

  def second(input, goal \\ {70, 70}) do
    queue = :queue.from_list([[{0, 0}]])
    obstacles = parse(input)

    index =
      length(obstacles)..1//-1
      |> Enum.find(fn len ->
        obstacles
        |> Enum.take(len)
        |> Enum.into(MapSet.new(), &List.to_tuple/1)
        |> then(&(bfs(queue, goal, &1))) != :blocked
      end)

    obstacles
    |> Enum.at(index)
    |> Enum.join(",")
  end

  defp bfs(queue, {xm, ym} = goal, obstacles, explored \\ MapSet.new()) do
    case :queue.out(queue) do
      {{:value, [^goal | t]}, _} ->
        length(t)
      {{:value, [pos | _] = path}, new_queue} ->
        adj =
          pos
          |> adjacent()
          |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or x > xm or y > ym end)
          |> Enum.reject(&(MapSet.member?(obstacles, &1) or MapSet.member?(explored, &1)))

        adj
        |> Enum.map(&([&1 | path]))
        |> Enum.reduce(new_queue, &:queue.in/2)
        |> bfs(goal, obstacles, MapSet.union(explored, MapSet.new(adj)))
      {:empty, _} ->
        :blocked
    end
  end

  defp adjacent({x, y}), do: [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]

  defp parse(input) do
    input
    |> String.split(["\n", ","])
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end
end
