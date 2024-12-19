defmodule Day19 do
  use Memoize

  def first(input) do
    {patterns, designs} = parse(input)

    Enum.count(designs, &arrangements(&1, patterns) != 0)
  end

  def second(input) do
    {patterns, designs} = parse(input)

    Enum.reduce(designs, 0, &(&2 + arrangements(&1, patterns)))
  end

  defmemop arrangements("", _patterns), do: 1
  defmemop arrangements(design, patterns) do
    patterns
    |> Enum.map(&(extract(&1, design)))
    |> Enum.filter(&(&1))
    |> Enum.reduce(0, &(&2 + arrangements(&1, patterns)))
  end

  defp extract(pattern, design) do
    case design do
      ^pattern <> rest -> rest
      _ -> nil
    end
  end

  defp parse(input) do
    [a, b] = String.split(input, "\n\n")

    {String.split(a, ", "), String.split(b)}
  end
end
