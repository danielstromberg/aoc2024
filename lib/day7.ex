defmodule Day7 do
  def first(input) do
    input
    |> parse()
    |> Enum.filter(fn x -> solvable?(x, [&+/2, &*/2]) end)
    |> Enum.reduce(0, fn [eq | _], acc -> acc + eq end)
  end

  def second(input) do
    input
    |> parse()
    |> Enum.filter(fn x -> solvable?(x, [&+/2, &*/2, &concat_digits/2]) end)
    |> Enum.reduce(0, fn [eq | _], acc -> acc + eq end)
  end

  defp solvable?([eq, first | rest], funs) do
    rest
    |> possible_values(first, funs)
    |> List.flatten()
    |> Enum.member?(eq)
  end

  defp possible_values([], acc, _), do: acc
  defp possible_values([h | t], acc, funs) do
    for fun <- funs do
      possible_values(t, fun.(acc, h), funs)
    end
  end

  defp concat_digits(a, b) do
    a_digits = Integer.digits(a)
    b_digits = Integer.digits(b)

    Integer.undigits(a_digits ++ b_digits)
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, [": ", " "]))
    |> Enum.map(fn r -> Enum.map(r, &String.to_integer/1) end)
  end
end
