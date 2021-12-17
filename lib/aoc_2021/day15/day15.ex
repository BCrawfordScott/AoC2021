defmodule Aoc2021.Day15 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  @travel_deltas [
    {1, 0},
    {0, 1},
    {0, -1},
    {-1, 0}
  ]

  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> map_input()
    |> build_algo_inputs()
    |> dijkstra({0, 0})
    |> extract_risk()
  end

  def part2, do: 2819 # part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> build_large_map()
    |> map_input()
    |> build_algo_inputs()
    |> dijkstra({0, 0})
    |> extract_risk()
  end

  defp build_algo_inputs({input_map, destination}) do
    {
      input_map, # The graph as a Map of {x, y} => {risk, total_risk}
      input_map |> Map.keys |> MapSet.new(), # Set of unvisited nodes, all the keys in the input_map
      destination # destination node, as determined by the maximum idxs
    }
  end

  defp build_large_map(input) do
    large_rows = input |> Enum.map(&build_large_row/1)

    0..4
    |> Enum.reduce([], fn iteration, current_block ->
      augmented_block = large_rows |> Enum.map(fn row ->
        row
        |> Enum.map(fn risk ->
          case risk + iteration do
            val when val > 9 -> rem(val, 9)
            val -> val
          end
        end)
      end)

      current_block ++ augmented_block
    end)
  end

  defp build_large_row(row) do
    0..4
    |> Enum.reduce([], fn iteration, current_row ->
      augmented_row = row |> Enum.map(fn risk ->
        case risk + iteration do
          val when val > 9 -> rem(val, 9)
          val -> val
        end
      end)
      current_row ++ augmented_row
    end)
  end

  def dijkstra({graph, unvisited, destination}, start) do
    run(
      { Map.put(graph, start, {0, 0}), unvisited, destination },
      start
    )
  end

  defp extract_risk({_position, {_, total_risk}}), do: total_risk

  defp map_input(input) do
    map = input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {risk_row, y}, grid ->
      row = risk_row
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {risk, x}, row_map ->
        Map.merge(row_map, %{ {x, y} => {risk, nil} })
      end)
      Map.merge(grid, row)
    end)

    { map, Enum.max(Map.keys(map), &sort_coords/2)}
  end

  defp parse_input(path) do
    path
    |> Input.to_array()
    |> Enum.map(fn string -> String.split(string, "", trim: true) |> Enum.map(&String.to_integer/1) end)
  end

  defp run(inputs, nil), do: inputs
  defp run({graph, unvisited, destination}, position) do
    with {_, nil} <- graph[position] do
      "Error - unable to find path to destination from position: #{position}"
    else {_, current_risk } ->
      {x, y} = position
      updated_graph = @travel_deltas |> Enum.reduce(graph, fn {dx, dy}, next_graph ->
        neighbor = {x + dx, y + dy}
        case MapSet.member?(unvisited, neighbor) do
          false -> next_graph
          true -> case graph[neighbor] do
            nil -> next_graph
            {risk, total_risk} -> case current_risk + risk < total_risk do
              false -> next_graph
              true -> Map.put(next_graph, neighbor, {risk, current_risk + risk})
            end
          end
        end
      end)

      updated_unvisited = MapSet.delete(unvisited, position)

      case MapSet.member?(updated_unvisited, destination) do
        false -> {destination, updated_graph[destination]}
        true -> next_position = unvisited_with_lowest_risk(updated_unvisited, updated_graph)
          run({updated_graph, updated_unvisited, destination}, next_position)
      end
    end
  end

  defp sort_coords({x1, y1}, {x2, y2}), do: x1 + y1 >= x2 + y2
  defp unvisited_with_lowest_risk(unvisited, graph) do
    unvisited
    |> MapSet.to_list()
    |> Enum.min(fn position1, position2 ->
      {_, total_risk1} = graph[position1]
      {_, total_risk2} = graph[position2]

      total_risk1 <= total_risk2
    end)
  end
end
