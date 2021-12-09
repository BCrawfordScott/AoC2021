defmodule Aoc2021.Day9 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"

  def part1, do: part1(@input_file)
  def part1(path) do
    vent_map = path |> parse_input() |> build_vent_map()
    vent_positions = vent_map |> Map.keys()

    vent_positions
    |> Enum.reduce(0, fn vent, total_threat ->
      vent_value = Map.get(vent_map, vent)
      adjacent_vents = gather_adjacent_positions(vent)
      case Enum.all?(adjacent_vents, fn a_vent -> vent_map[a_vent] > vent_value end) do
        true -> total_threat + vent_value + 1
        false -> total_threat
      end
    end)
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    vent_map = path |> parse_input() |> build_vent_map()
    vent_positions = vent_map |> Map.keys()

    vent_positions
    |> Enum.reduce({[], MapSet.new}, fn position, {basin_sizes, visited_vents} ->
      {basin_val, recent_vents} = basin_value(position, vent_map, visited_vents)
      {[ basin_val | basin_sizes], MapSet.union(visited_vents, recent_vents)}
    end)
    |> calculate_biggest_basins()
  end

  defp parse_input(path) do
    path
    |> Input.to_array()
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
  end

  defp build_vent_map(vents) do
    vents
    |> Enum.with_index()
    |> Enum.reduce(%{}, &map_vent_row/2)
  end

  defp map_vent_row({vent_row, y}, vent_map) do
    vent_row
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {vent, x}, row_map ->
      vent_position = %{ {x, y} => vent }
      Map.merge(row_map, vent_position)
    end)
    |> Map.merge(vent_map)
  end

  defp gather_adjacent_positions({x, y}) do
    [
      {x+1, y},
      {x-1, y},
      {x, y+1},
      {x, y-1},
    ]
  end

  defp basin_value(position, vent_map, visited_vents) do
    case MapSet.member?(visited_vents, position) do
      true -> {0, visited_vents}
      _ -> case vent_map[position] do
            nil -> {0, MapSet.put(visited_vents, position)}
            9 -> {0, MapSet.put(visited_vents, position)}
            _ -> gather_adjacent_positions(position)
                 |> Enum.reduce({1, MapSet.put(visited_vents, position)}, fn pos, {total_val, all_visited} ->
                      {basin_val, recently_visited} = basin_value(pos, vent_map, all_visited)
                      {basin_val + total_val, MapSet.union(recently_visited, all_visited)}
                    end)
          end
    end

  end

  defp calculate_biggest_basins({basins, _vents}) do
    basins
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.reduce(fn el, acc -> el * acc end)
  end
end
