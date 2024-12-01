defmodule InputReader do
  def read(day, sample) do
    folder = if sample, do: "sample", else: "private"

    File.read!("./input/#{folder}/#{day}.txt")
  end
end
