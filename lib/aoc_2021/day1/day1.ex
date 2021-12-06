defmodule Aoc2021.Day1 do

  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  # @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  def part1 do
    @input_file
    |> parse_input()
    |> compare(1)
  end

  def part2 do
    @input_file
    |> parse_input()
    |> compare(3)
  end

  defp parse_input(path) do
    path
    |> Input.to_array()
    |> Enum.map(&String.to_integer/1)
  end

  defp compare(list, offset) do
    {increases, _} = list |> Enum.reduce({[], 0}, fn depth, {acc, idx} ->
      if depth < Enum.at(list, idx + offset, 0), do: {[1|acc], idx + 1}, else: {[0|acc], idx + 1}
    end)
    Enum.sum(increases)
  end
end
