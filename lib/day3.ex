defmodule Day3 do
  def first(input), do: calc(input, false)
  def second(input), do: calc(input, true)

  defp calc(string, do_instr_enabled), do: do_calc(string, 0, do_instr_enabled, true)
  defp do_calc(string, acc, do_instr_enabled, mul_enabled)
  defp do_calc("", acc, _, _), do: acc
  defp do_calc("mul(" <> rest, acc, do_instr_enabled, true) do
    with {a, "," <> rest} <- Integer.parse(rest),
         {b, ")" <> rest} <- Integer.parse(rest) do
      do_calc(rest, acc + a * b, do_instr_enabled, true)
    else
      _ -> do_calc(rest, acc, do_instr_enabled, true)
    end
  end
  defp do_calc("don't()" <> rest, acc, true, _mul_enabled), do: do_calc(rest, acc, true, false)
  defp do_calc("do()" <> rest, acc, true, _mul_enabled), do: do_calc(rest, acc, true, true)
  defp do_calc(<<_::binary-size(1), rest::binary>>, acc, d, m), do: do_calc(rest, acc, d, m)
end
