defmodule Mix.Tasks.Aoc2024.Solve do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    use_sample_input = Enum.member?(args, "--test")
    day = get_day(args)
    input = InputReader.read(day, use_sample_input)
    module = "Elixir.Day#{day}" |> String.to_existing_atom()

    p1 = apply(module, :first, [input])
    p2 = apply(module, :second, [input])

    IO.puts("""
    ----------------------------------------
    First:
    #{p1}

    Second:
    #{p2}
    """)
  end

  defp get_day(args) do
    case Enum.find(args, &String.starts_with?(&1, "--day=")) do
      nil -> raise "day argument not passed."
      "--day=" <> day -> String.to_integer(day)
    end
  end
end
