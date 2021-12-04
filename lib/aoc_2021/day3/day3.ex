defmodule Aoc2021.Day3 do

  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  def test(:part_one), do: part1(@test_file)
  def test(:part_two), do: part2(@test_file)

  def part1, do: part1(@input_file)
  defp part1(file) do
    computed = file
    |> Input.to_array()
    |> Enum.map(&to_individual_ints/1)
    |> Enum.reduce(fn bin_array, acc -> Enum.zip_with(bin_array, acc, fn x, y -> x + y end) end)

    gamma = String.to_integer(most_frequent_binary(computed), 2)
    epsilon = String.to_integer(least_frequent_binary(computed), 2)

    gamma * epsilon
  end

  def part2, do: part2(@input_file)
  defp part2(file) do
    input_array = file
    |> Input.to_array()

    oxygen = process_oxygen(input_array, 0)
    co2 = process_co2(input_array, 0)

    String.to_integer(oxygen, 2) * String.to_integer(co2, 2)
  end

  defp process_oxygen([last | []], _count), do: last
  defp process_oxygen(bin_list, count) do
    computed = bin_list |> compute_frequency()
    filter = most_frequent_binary(computed)
    new_bin_list = Enum.filter(bin_list, fn bin_string -> String.at(bin_string, count) === String.at(filter, count) end)

    process_oxygen(new_bin_list, count + 1)
  end

  defp process_co2([last | []], _count), do: last
  defp process_co2(bin_list, count) do
    computed = bin_list |> compute_frequency()
    filter = least_frequent_binary(computed)
    new_bin_list = Enum.filter(bin_list, fn bin_string -> String.at(bin_string, count) === String.at(filter, count) end)

    process_co2(new_bin_list, count + 1)
  end

  defp to_individual_ints(binary_string) do
    binary_string
    |> String.split("", trim: true)
    |> Enum.map( fn
      "1" -> 1
      "0" -> -1
    end)
  end

  defp most_frequent_binary(bin_array) do
    bin_array
    |> Enum.map(fn
      int when int >= 0 -> 1
      int when int < 0 -> 0
    end)
    |> Enum.join("")
  end

  defp least_frequent_binary(bin_array) do
    bin_array
    |> Enum.map(fn
      int when int >= 0 -> 0
      int when int < 0 -> 1
    end)
    |> Enum.join("")
  end

  defp compute_frequency(bin_list) do
    bin_list
    |> Enum.map(&to_individual_ints/1)
    |> Enum.reduce(fn bin_array, acc -> Enum.zip_with(bin_array, acc, fn x, y -> x + y end) end)
  end
end
