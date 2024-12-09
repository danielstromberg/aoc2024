defmodule Day9 do
  def first(input) do
    chunk =
      input
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.with_index()

    len = Enum.reduce(chunk, 0, fn {l, _}, acc -> acc + hd(l) end)
    queue = chunk |> Enum.reverse() |> Enum.map(fn {l, i} -> {i, hd(l)} end)

    Enum.reduce_while(chunk, {0, 0, queue}, fn
      _, {sum, index, _} when index == len ->
        {:halt, sum}
      {[size, space], val}, {sum, index, qu} ->
        limit = min(index + size - 1, len - 1)
        chk1 = Enum.reduce(index..limit, 0, &(&2 + &1 * val))
        take = min(len - limit - 1, space)
        {elems, new_qu} = pull(qu, take)
        upper = limit + take
        chk2 = [limit + 1..upper, elems] |> Enum.zip_reduce(0, fn [a, b], acc -> acc + a * b end)

        {:cont, {sum + chk1 + chk2, upper + 1, new_qu}}
    end)
  end

  def second(input) do
    chunk =
      input
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.with_index()

    queue = chunk |> Enum.reverse() |> Enum.map(fn {l, i} -> {i, hd(l)} end)

    {chk, _, _} =
      Enum.reduce(chunk, {0, 0, queue}, fn
        {[size, space], val}, {sum, index, qu} ->

          chk1 =
            if Enum.any?(qu, fn {v, _a} -> val  == v end) do
              Enum.reduce(index..index + size - 1, 0, &(&2 + &1 * val))
            else
              0
            end

          {moved, new_qu} = find_pull(qu, space, val)

          moved_vals = Enum.reduce(moved, [], fn {v, a}, acc -> acc ++ List.duplicate(v, a) end)

          chk2 =
            moved_vals
            |> Enum.with_index(index + size)
            |> Enum.reduce(0, fn {a, b}, acc -> acc + a * b end)

          {sum + chk1 + chk2, index + size + space, new_qu}

        _, {sum, index, qu} ->
          {sum, index, qu}
      end)
    chk
  end

  defp find_pull(list, space, val) do
    index = Enum.find_index(list, fn {v, size} -> size <= space and v > val end)

    if index == nil do
      {[], list}
    else
      {elem, upd} = List.pop_at(list, index)
      {x, rest} = find_pull(upd, space - elem(elem, 1), val)
      {[elem | x], rest}
    end
  end

  defp pull(list, 0), do: {[], list}
  defp pull([{val, 1} | t], count) do
    {x, rest} = pull(t, count - 1)

    {[val | x], rest}
  end
  defp pull([{val, amount} | t], count) do
    {x, rest} = pull([{val, amount - 1} | t], count - 1)
    {[val | x], rest}
  end
end
