defmodule Aoc2021.Day5 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  def test(:part_one), do: part1(@test_file)
  def test(:part_two), do: part2(@test_file)

  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> Enum.filter(&horizontal_vertical_line/1)
    |> Enum.reduce(%{}, fn line, line_record -> record_line(line, line_record) end)
    |> Map.values()
    |> Enum.count(fn val -> val > 1 end)
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> Enum.reduce(%{}, fn line, line_record -> record_line(line, line_record) end)
    |> Map.values()
    |> Enum.count(fn val -> val > 1 end)
  end

  defp get_points({[x1, y1], [x2, y2]}) when abs(x1 - x2) == abs(y1 - y2), do: Enum.zip(x1..x2, y1..y2)
  defp get_points({[x1, y1], [x2, y2]}) when x1 == x2, do: Enum.map(y1..y2, fn y -> {x1, y} end)
  defp get_points({[x1, y1], [x2, y2]}) when y1 == y2, do: Enum.map(x1..x2, fn x -> {x, y1} end)
  defp get_points(_), do: []

  defp horizontal_vertical_line({[x1, y1], [x2, y2]}) do
    x1 == x2 || y1 == y2
  end

  defp parse_input(path) do
    path
    |> Input.to_array() # Read the input file and split on \n
    |> Enum.map(fn point_range ->
      [start_point, end_point] = String.split(point_range, " -> ", trim: true)
      start_coords = String.split(start_point, ",", trim: true) |> Enum.map(&String.to_integer/1)
      end_coords = String.split(end_point, ",", trim: true) |> Enum.map(&String.to_integer/1)

      {start_coords, end_coords}
    end)
  end

  defp record_line(line, line_record) do
    points = get_points(line)
    Enum.reduce(points, line_record, &record_point/2)
  end

  defp record_point(point, record) do
    current_val = Map.get(record, point, 0)
    Map.put(record, point, current_val + 1)
  end
end
