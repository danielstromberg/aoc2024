defmodule Day2 do
  def first(input) do
    input
    |> parse()
    |> Enum.count(&safe?/1)
  end

  def second(input) do
    input
    |> parse()
    |> Enum.count(&safe?(&1) or safe_by_deletion?(&1))
  end

  defp safe?(levels) do
    diff =
      levels
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    all_incr_or_decr =
      diff
      |> Enum.uniq_by(&(&1 >= 0))
      |> Enum.count() == 1

    all_incr_or_decr and Enum.all?(diff, &abs(&1) in 1..3)
  end

  defp safe_by_deletion?(levels) do
    0..length(levels) - 1
    |> Enum.map(&List.delete_at(levels, &1))
    |> Enum.any?(&safe?/1)
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
