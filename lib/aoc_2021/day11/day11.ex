defmodule Aoc2021.Day11 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  @octo_deltas [
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, 1},
    {1, 1},
    {1, 0},
    {1, -1},
    {0, -1},
  ]

  def part1, do: part1(@input_file)
  def part1(path) do
    octopus_map = path |> parse_input() |> map_octopuses()
    1..100
    |> Enum.reduce({0, octopus_map}, &step_and_count_flashes/2 )
    |> Tuple.to_list()
    |> List.first()
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> map_octopuses()
    |> find_full_flash()
  end

  defp parse_input(path) do
    path
    |> Input.to_array()
    |> Enum.map(fn row -> String.split(row, "", trim: true) |> Enum.map(&String.to_integer/1) end)
  end

  defp map_octopuses(input_grid) do
    input_grid
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {octopus_row, y}, octo_map ->
      octopus_row
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {octopus, x}, octo_row_map ->
         Map.put(octo_row_map, {x, y}, octopus)
      end)
      |> Map.merge(octo_map)
    end)
  end

  defp step(octo_map) do
    positions = octo_map |> Map.keys()
    Enum.reduce(positions, octo_map, fn position, current_map ->
      updated_positions = advance_energy(position, current_map)
      Map.merge(current_map, updated_positions)
    end)
  end

  defp advance_energy(position, octo_map) do
    case Map.get(octo_map, position, :none) do
      :none -> octo_map
      octopus when octopus == 9 -> flash(position, Map.merge(octo_map, %{position => 10}))
      octopus -> Map.merge(octo_map, %{ position => octopus + 1 })
    end
  end

  defp flash({x, y}, octo_map) do
    @octo_deltas
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.reduce(octo_map, &advance_energy/2)
  end

  defp count_flashes(octo_map) do
    octo_map
    |> Map.keys()
    |> Enum.reduce(0, fn position, total_flashes ->
      case octo_map[position] do
        0 -> total_flashes + 1
        _ -> total_flashes
      end
    end)
  end

  defp mark_flashes(octo_map) do
    octo_map
    |> Map.keys()
    |> Enum.reduce(octo_map, fn position, updated_map ->
      case updated_map[position] do
        octo when octo > 9 -> Map.merge(updated_map, %{position => 0})
        _ -> updated_map
      end
    end)
  end

  defp step_and_count_flashes(_step, {count, octo_map}) do
    advanced_map = octo_map |> step() |> mark_flashes()
    {count + count_flashes(advanced_map), advanced_map}
  end

  defp find_full_flash(octo_map), do: find_full_flash(octo_map, 1)
  defp find_full_flash(octo_map, step) do
    advanced_map = octo_map |> step() |> mark_flashes()
    case count_flashes(advanced_map) do
      100 -> step
      _ -> find_full_flash(advanced_map, step + 1)
    end
  end
end
