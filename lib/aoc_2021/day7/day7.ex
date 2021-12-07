defmodule Aoc2021.Day7 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"

  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> calc_fuel_for_postions()
    |> Enum.min()
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> calc_fuel_for_postions(:correct)
    |> Enum.min()
  end

  defp parse_input(path) do
    path
    |> Input.read()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp calc_fuel_for_postions(crabs_positions) do
    min = Enum.min(crabs_positions)
    max = Enum.max(crabs_positions)

    Enum.map(min..max, fn final_pos ->
      Enum.reduce(crabs_positions, 0, fn pos, total_fuel -> abs(final_pos - pos) + total_fuel end)
    end)
  end

  defp calc_fuel_for_postions(crabs_positions, :correct) do
    min = Enum.min(crabs_positions)
    max = Enum.max(crabs_positions)

    Enum.map(min..max, fn final_pos ->
      Enum.reduce(crabs_positions, 0, fn pos, total_fuel -> real_fuel(abs(final_pos - pos)) + total_fuel end)
    end)
  end

  defp real_fuel(num), do: Integer.floor_div(num * (num + 1), 2)
end
