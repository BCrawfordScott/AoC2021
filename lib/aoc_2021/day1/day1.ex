defmodule Aoc2021.Day1 do

  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  # @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  # First attempt, naive solution
  def part1 do
    # IO.puts @input_file
    @input_file
    |> Input.to_array()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({ nil, 0 }, &(track_increases(&1, &2)))
    |> total_increases()
  end

  def part2 do
    @input_file
    |> Input.to_array()
    |> Enum.map(&String.to_integer/1)
    |> reduce_by_window
    |> Enum.reduce({ nil, 0 }, &(track_increases(&1, &2)))
    |> total_increases()
  end

  defp track_increases(depth, {nil, _}), do: { depth, 0 }
  defp track_increases(depth, {last_depth, num_increases}) when depth > last_depth, do: { depth, num_increases + 1 }
  defp track_increases(depth, {_last_depth, num_increases}), do: { depth, num_increases }

  defp total_increases({ _depth, num_increases }), do: num_increases

  defp reduce_by_window([a | [b | [c | []]]]), do: [a + b + c]
  defp reduce_by_window([a | [b | [c | rest]]]), do: [a + b + c | reduce_by_window([b | [c | rest]])]


  # Second attempt after studying other solutions:
  def refactor_part1, do: compare(1)
  def refactor_part2, do: compare(3)

  defp parse_input(path) do
    path
    |> Input.to_array()
    |> Enum.map(&String.to_integer/1)
  end

  defp compare(offset) do
    list = parse_input(@input_file)
    {increases, _} = list |> Enum.reduce({[], 0}, fn depth, {acc, idx} ->
      if depth < Enum.at(list, idx + offset, 0), do: {[1|acc], idx + 1}, else: {[0|acc], idx + 1}
    end)
    Enum.sum(increases)
  end
end
