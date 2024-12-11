defmodule Day11 do
  def first(input), do: solve(input, 25)
  def second(input), do: solve(input, 75)

  defp solve(input, count) do
    input
    |> String.split()
    |> Enum.into(%{}, &({String.to_integer(&1), 1}))
    |> blink(count)
    |> Enum.reduce(0, fn {_, amount}, acc -> acc + amount end)
  end

  defp blink(state, 0), do: state
  defp blink(state, count) do
    state
    |> Enum.flat_map(
      fn {number, amount} ->
        number
        |> transform()
        |> Enum.map(&({&1, amount}))
      end)
    |> Enum.reduce(%{}, fn {number, amount}, acc -> Map.update(acc, number, amount, &(&1 + amount)) end)
    |> blink(count - 1)
  end

  defp transform(0), do: [1]
  defp transform(number) do
    len = :math.log10(number + 1) |> ceil()

    if rem(len, 2) == 0 do
      number
      |> Integer.digits()
      |> Enum.chunk_every(div(len, 2))
      |> Enum.map(&Integer.undigits/1)
    else
      [number * 2024]
    end
  end
end
