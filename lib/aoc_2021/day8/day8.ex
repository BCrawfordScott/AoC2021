defmodule Aoc2021.Day8 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"

  def part1, do: part1(@input_file)
  def part1(path) do

    path
    |> parse_input()
    |> Enum.reduce(0, fn {_input, output}, acc ->
      Enum.reduce(output, 0, fn string, acc ->
        case String.length(string) do
          l when l in [2, 3, 4, 7] -> acc + 1
          _ -> acc
        end
      end) + acc
    end)
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> Enum.map(&process_line_output/1)
    |> Enum.sum()
  end

  defp parse_input(path) do
    path
    |> Input.to_array()
    |> Enum.map(fn line ->
      [input, output] = String.split(line, " | ", trim: true)
      {
        String.split(input, " ", trim: true),
        String.split(output, " ", trim: true)
      }
    end)
  end

  defp process_line_output({input, output}) do
    output
    |> Enum.map(fn num -> determine_number(num, input) end)
    |> Enum.join("")
    |> String.to_integer()
  end

  defp determine_number(num_code, input) do
    one = Enum.find(input, fn str -> String.length(str) == 2 end)
    four = Enum.find(input, fn str -> String.length(str) == 4 end)

    char_list = String.to_charlist(num_code)

    case String.length(num_code) do
      2 -> "1"
      3 -> "7"
      4 -> "4"
      5 -> case length(char_list -- String.to_charlist(one)) do
          3 -> "3"
          _ -> case length(char_list -- String.to_charlist(four)) do
            3 -> "2"
            _ -> "5"
          end
        end
      6 -> case length(char_list -- String.to_charlist(one)) do
        5 -> "6"
        _ -> case length(char_list -- String.to_charlist(four)) do
          2 -> "9"
          _ -> "0"
        end
      end
      7 -> "8"
    end
  end
end
