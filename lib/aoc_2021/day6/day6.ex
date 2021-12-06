defmodule Aoc2021.Day6 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  @initial_counts %{
    0 => 0,
    1 => 0,
    2 => 0,
    3 => 0,
    4 => 0,
    5 => 0,
    6 => 0,
    7 => 0,
    8 => 0
  }

  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> Enum.reduce(@initial_counts, fn fish, counts ->
      curr_val = Map.get(counts, fish)
      Map.put(counts, fish, curr_val + 1)
    end)
    |> process_fish(80)
    |> Map.values()
    |> Enum.sum
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> Enum.reduce(@initial_counts, fn fish, counts ->
      curr_val = Map.get(counts, fish)
      Map.put(counts, fish, curr_val + 1)
    end)
    |> process_fish(256)
    |> Map.values()
    |> Enum.sum
  end

  defp parse_input(path) do
    path
    |> Input.read()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp process_fish(fish_counts, 0), do: fish_counts
  defp process_fish(fish_counts, days_left) do
    %{
      0 => zero_fish,
      1 => one_fish,
      2 => two_fish,
      3 => three_fish,
      4 => four_fish,
      5 => five_fish,
      6 => six_fish,
      7 => seven_fish,
      8 => eight_fish,
    } = fish_counts

    new_counts = %{
      0 => one_fish,
      1 => two_fish,
      2 => three_fish,
      3 => four_fish,
      4 => five_fish,
      5 => six_fish,
      6 => seven_fish + zero_fish,
      7 => eight_fish,
      8 => zero_fish,
    }

    process_fish(new_counts, days_left - 1)
  end
end
