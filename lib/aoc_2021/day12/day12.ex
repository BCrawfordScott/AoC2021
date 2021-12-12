defmodule Aoc2021.Day12 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"

  def part1, do: part1(@input_file)
  def part1(path) do
    cave_tree = path |> parse_input() |> build_cave_tree()

    count_valid_paths("start", cave_tree)
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    cave_tree = path |> parse_input() |> build_cave_tree()

    count_valid_paths2("start", cave_tree)
  end

  defp add_cave_path({"start", to}, cave_tree), do: Map.merge(cave_tree, %{ "start" => [ to | Map.get(cave_tree, "start", []) ] })
  defp add_cave_path({to, "start"}, cave_tree), do: Map.merge(cave_tree, %{ "start" => [ to | Map.get(cave_tree, "start", []) ] })
  defp add_cave_path({from, "end"}, cave_tree), do: Map.merge(cave_tree, %{ from => [ "end" | Map.get(cave_tree, from, []) ] })
  defp add_cave_path({from, to}, cave_tree) do
    new_paths = %{
      from => [ to | Map.get(cave_tree, from, []) ],
      to => [ from | Map.get(cave_tree, to, []) ]
    }
    Map.merge(cave_tree, new_paths)
  end

  defp build_cave_tree(single_paths), do: single_paths |> Enum.reduce(%{}, &add_cave_path/2)

  defp count_valid_paths("start", cave_tree), do: Map.get(cave_tree, "start") |> Enum.map(fn next_node -> count_valid_paths(next_node, cave_tree, MapSet.new()) end) |> Enum.sum()
  defp count_valid_paths("end", _cave_tree, _visited_caves), do: 1
  defp count_valid_paths(node, cave_tree, visited_caves) do
    case Regex.match?(~r/[a-z]/, node) do
      true -> case MapSet.member?(visited_caves, node) do
        true -> 0
        false -> Map.get(cave_tree, node) |> Enum.map(fn next_node -> count_valid_paths(next_node, cave_tree, MapSet.put(visited_caves, node)) end) |> Enum.sum()
      end
      false -> Map.get(cave_tree, node) |> Enum.map(fn next_node -> count_valid_paths(next_node, cave_tree, MapSet.put(visited_caves, node)) end) |> Enum.sum()
    end
  end
  defp count_valid_paths2("start", cave_tree), do: Map.get(cave_tree, "start") |> Enum.map(fn next_node -> count_valid_paths2(next_node, cave_tree, MapSet.new()) end) |> Enum.sum()
  defp count_valid_paths2("end", _cave_tree, _visited_caves), do: 1
  defp count_valid_paths2(node, cave_tree, visited_caves) do
    case Regex.match?(~r/[a-z]/, node) do
      true -> case MapSet.member?(visited_caves, node) do
        true -> case MapSet.member?(visited_caves, :double) do
          true -> 0
          false -> Map.get(cave_tree, node) |> Enum.map(fn next_node -> count_valid_paths2(next_node, cave_tree, MapSet.put(visited_caves, :double)) end) |> Enum.sum()
        end
        false -> Map.get(cave_tree, node) |> Enum.map(fn next_node -> count_valid_paths2(next_node, cave_tree, MapSet.put(visited_caves, node)) end) |> Enum.sum()
      end
      false -> Map.get(cave_tree, node) |> Enum.map(fn next_node -> count_valid_paths2(next_node, cave_tree, MapSet.put(visited_caves, node)) end) |> Enum.sum()
    end
  end

  defp parse_input(path) do
    path
    |> Input.to_array()
    |> Enum.map(&to_path_tuple/1)
  end

  defp to_path_tuple(path), do: String.split(path, "-", trim: true) |> List.to_tuple()
end
