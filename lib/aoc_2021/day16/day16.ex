defmodule Aoc2021.Day16 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"

  @hex_map %{
    "0" => [0, 0, 0, 0],
    "1" => [0, 0, 0, 1],
    "2" => [0, 0, 1, 0],
    "3" => [0, 0, 1, 1],
    "4" => [0, 1, 0, 0],
    "5" => [0, 1, 0, 1],
    "6" => [0, 1, 1, 0],
    "7" => [0, 1, 1, 1],
    "8" => [1, 0, 0, 0],
    "9" => [1, 0, 0, 1],
    "A" => [1, 0, 1, 0],
    "B" => [1, 0, 1, 1],
    "C" => [1, 1, 0, 0],
    "D" => [1, 1, 0, 1],
    "E" => [1, 1, 1, 0],
    "F" => [1, 1, 1, 1],
  }

  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> process_versions()
  end

  def part2, do: 2819 # part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
  end

  defp binary_to_int(binary), do: binary |> Enum.join("") |> String.to_integer(2)

  defp get_type(packet) do
    type = Enum.take(packet, 3) |> binary_to_int()
    { type, Enum.drop(packet, 3) }
  end

  defp get_version(packet) do
    version = Enum.take(packet, 3) |> binary_to_int()
    { version, Enum.drop(packet, 3) }
  end

  defp parse_input(path) do
    path
    |> Input.read()
    |> String.split("", trim: true)
    |> Enum.flat_map(fn hex -> @hex_map[hex] end)
  end

  defp process_literal(literal) do
    case Enum.take(literal, 5) do
      [0 | binary] -> { Enum.join(binary, "") |> String.to_integer(2), Enum.drop(literal, 5) }
      [1 | binary] -> { total, next_packet } = process_literal(Enum.drop(literal, 5))
        { total + (Enum.join(binary, "") |> String.to_integer(2)), next_packet }
    end
  end

  defp process_versions(packet) when length(packet) <= 3, do: 0
  defp process_versions(packet) do
    {version, packet_minus_version} = get_version(packet)
    {type, packet_minus_type} = get_type(packet_minus_version)
    case type do
      4 -> { _binary, next_packet } = process_literal(packet_minus_type)
        version + process_versions(next_packet)
      _operator -> case packet_minus_type do
          [0 | rest] -> version + process_versions(Enum.drop(rest, 15))
          [1 | rest] ->  version + process_versions(Enum.drop(rest, 11))
        end
    end
  end
end
