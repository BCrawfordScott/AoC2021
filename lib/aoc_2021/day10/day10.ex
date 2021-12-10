defmodule Aoc2021.Day10 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  @closing_char_map %{
    "[" => "]",
    "{" => "}",
    "(" => ")",
    "<" => ">",
  }
  @closing_char_vals %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
  }
  @completion_char_vals %{
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4,
  }
  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.reduce(0, fn line, total ->
      case corrupted?(line) do
        {:corrupted, char} -> total + @closing_char_vals[char]
        _ -> total
      end
    end)
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(fn line ->
      case corrupted?(line) do
        {:corrupted, _char} -> nil
        completion_string -> completion_string
      end
    end)
    |> Enum.reject(fn val -> val == nil end)
    |> Enum.map(&calc_completion_val/1)
    |> Enum.sort()
    |> get_middle_val()
  end

  defp parse_input(path) do
    path
    |> Input.to_array()
  end

  defp corrupted?(list), do: corrupted?(list, [])
  defp corrupted?([], stack), do: build_completion_string(stack)
  defp corrupted?([char | rest], stack) when char in ["[", "{", "(", "<"], do: corrupted?(rest, [char | stack])
  defp corrupted?([char | rest], [head | tail]) when char in ["]", "}", ")", ">"] do
    case @closing_char_map[head] == char do
      true -> corrupted?(rest, tail)
      false -> {:corrupted, char}
    end
  end

  defp build_completion_string([]), do: ""
  defp build_completion_string([char | rest]) do
    @closing_char_map[char] <> build_completion_string(rest)
  end

  defp calc_completion_val(completion_string) do
    String.split(completion_string, "", trim: true)
    |> Enum.reduce(0, fn char, total ->
      total * 5 + @completion_char_vals[char]
    end)
  end

  defp get_middle_val(list) do
    mid_idx = Integer.floor_div(length(list), 2)
    Enum.at(list, mid_idx)
  end
end
