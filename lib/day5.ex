defmodule Day5 do
  def first(input) do
    {rules, updates} = parse(input)

    updates
    |> Enum.filter(&valid_update?(&1, rules))
    |> Enum.map(&middle_number/1)
    |> Enum.sum()
  end

  def second(input) do
    {rules, updates} = parse(input)

    updates
    |> Enum.reject(&valid_update?(&1, rules))
    |> Enum.map(&fix_order(&1, rules))
    |> Enum.map(&middle_number/1)
    |> Enum.sum()
  end

  defp valid_update?([], _rules), do: true
  defp valid_update?([h | t], rules) do
    Enum.all?(t, &MapSet.member?(rules, {h, &1})) and valid_update?(t, rules)
  end

  defp fix_order(list, rules), do: Enum.sort(list, &MapSet.member?(rules, {&1, &2}))

  defp middle_number(list) do
    list
    |> length()
    |> div(2)
    |> then(&Enum.at(list, &1))
  end

  defp parse(input) do
    [s1, s2] = String.split(input, "\n\n")

    rules =
      s1
      |> String.split(["|", "\n"])
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.into(MapSet.new(), fn [a, b] -> {a, b} end)

    updates =
      s2
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)

    {rules, updates}
  end
end
