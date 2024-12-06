defmodule Mix.Tasks.Aoc2024.Solve do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    use_sample_input = Enum.member?(args, "--test")
    day = get_day(args)
    input = InputReader.read(day, use_sample_input)
    module = "Elixir.Day#{day}" |> String.to_existing_atom()

    {t1, p1} = :timer.tc(module, :first, [input])
    {t2, p2} = :timer.tc(module, :second, [input])

    e1 = t1 / 1_000_000
    e2 = t2 / 1_000_000

    IO.puts("""
    ----------------------------------------
    First (#{e1}s):
    #{p1}

    Second (#{e2}s):
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
