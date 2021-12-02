defmodule Aoc2021.Day2 do

  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  # @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  def part1 do
    parse_input()
    |> Enum.reduce({0, 0}, &process/2)
    |> compute_position()
  end

  def part2 do
    parse_input()
    |> Enum.reduce({0, 0, 0}, &process/2)
    |> compute_position()
  end

  defp parse_input, do: parse_input(@input_file)
  defp parse_input(file) do
    file
    |> Input.to_array()
    |> Enum.map(&String.split(&1, " "))
  end

  defp process([command, units], acc) when tuple_size(acc) == 2, do: input_command([command, String.to_integer(units)], acc)
  defp process([command, units], acc) when tuple_size(acc) == 3, do: process_command([command, String.to_integer(units)], acc)

  defp input_command(["forward", units], {current_depth, current_position}), do: {current_depth, current_position + units}
  defp input_command(["down", units], {current_depth, current_position}), do: {current_depth + units, current_position}
  defp input_command(["up", units], {current_depth, current_position}), do: {current_depth - units, current_position}

  defp process_command(["forward", units], {current_depth, current_position, current_aim}), do: {current_depth + (current_aim * units), current_position + units, current_aim}
  defp process_command(["down", units], {current_depth, current_position, current_aim}), do: {current_depth, current_position, current_aim + units}
  defp process_command(["up", units], {current_depth, current_position, current_aim}), do: {current_depth, current_position, current_aim - units}

  defp compute_position({ depth, position }), do: depth * position
  defp compute_position({ depth, position, _ }), do: depth * position
end
