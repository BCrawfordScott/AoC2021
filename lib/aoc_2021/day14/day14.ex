defmodule Aoc2021.Day14 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"

  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> generate_initial_counts()
    |> grow(10)
    |> calc_poly_counts()
    |> element_difference()
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> generate_initial_counts()
    |> grow(40)
    |> calc_poly_counts()
    |> element_difference()
  end

  defp calc_poly_counts(polymer_counts) do
    polymer_counts
    |> Map.keys()
    |> Enum.reduce(%{}, fn pair, single_counts ->
      count = polymer_counts[pair] / 4
      pair
      |> String.split("", trim: true)
      |> Enum.reduce(single_counts, fn poly, next_counts ->
        first_addition = Map.put(next_counts, poly, Map.get(next_counts, poly, 0) + count)
        Map.put(first_addition, poly, Map.get(first_addition, poly, 0) + count)
      end)
    end)
  end

  defp element_difference(poly_counts) do
    vals = Map.values(poly_counts)

    round(Enum.max(vals)) - round(Enum.min(vals))
  end

  defp generate_initial_counts({start_poly, insert_commands}) do
    blank_counts =  insert_commands
                    |> Map.keys()
                    |> Enum.reduce(%{}, fn pair, blank_counts ->
                      Map.put(blank_counts, pair, 0)
                    end)
    {
      start_poly
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(blank_counts, fn [first, second], initial_counts ->
        last_pair_val = Map.get(initial_counts, first<>second, 0)
        Map.put(initial_counts, first<>second, last_pair_val + 1)
      end),
      insert_commands
    }
  end

  defp grow({polymer_counts, _insert_commands}, 0), do: polymer_counts
  defp grow({polymer_counts, insert_commands}, steps) do
    next_counts = polymer_counts
                  |> Map.keys()
                  |> Enum.reduce(%{}, fn key, next_poly_counts ->
                    middle = insert_commands[key]
                    [first, second] = String.split(key, "", trim: true)
                    {first_key, second_key} = {first<>middle, middle<>second}
                    additions = polymer_counts[key]
                    last_val1 = Map.get(next_poly_counts, first_key, 0)
                    last_val2 = Map.get(next_poly_counts, second_key, 0)

                    next_poly_counts
                    |> Map.put(first_key, last_val1 + additions)
                    |> Map.put(second_key, last_val2 + additions)
                  end)

    grow({next_counts, insert_commands}, steps - 1)
  end

  defp parse_input(path) do
    [ start, insert_commands ] = path |> Input.read()|> String.split("\n\n", trim: true)

    {
      String.split(start, "", trim: true),
      insert_commands
      |> String.split("\n")
      |> Enum.reduce(%{}, fn command, acc ->
        [pair, insert] = String.split(command, " -> ", trim: true)
        Map.put(acc, pair, insert)
      end)
    }
  end
end
