defmodule Aoc2021.Day13 do
  @input_file Path.dirname(__ENV__.file) <> "/input.txt"

  def part1, do: part1(@input_file)
  def part1(path) do
    {dots, folds} = path |> parse_input()
    sheet = MapSet.new(dots)
    first_fold = List.first(folds)

    fold_sheet(sheet, first_fold) |> MapSet.size()
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    {dots, folds} = path |> parse_input()
    sheet = MapSet.new(dots)

    folds
    |> Enum.reduce(sheet, fn fold, sheet ->
      fold_sheet(sheet, fold)
    end)
    |> paint()
  end

  defp parse_input(path) do
    input = path |> Input.read()
    [dot_positions, folds] = String.split(input, "\n\n", trim: true)

    dot_tuples = dot_positions |> String.split("\n", trim: true) |> Enum.map(fn pos ->
      pos
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
    fold_tuples = folds |> String.split("\n", trim: true) |> Enum.map(fn fold ->
      fold
      |> String.replace("fold along ", "")
      |> String.split("=", trim: true)
      |> Enum.map(fn char ->
        case Regex.match?(~r/\d+/, char) do
          true -> String.to_integer(char)
          false -> char
        end
      end)
      |> List.to_tuple()
    end)

    { dot_tuples, fold_tuples }
  end

  defp find_sheet_size(dots) do
    Enum.reduce(dots, {0, 0}, fn {x, y}, {max_x, max_y} ->
      { Enum.max([x, max_x]), Enum.max([y, max_y]) }
    end)
  end

  defp fold_sheet(sheet, {plane, line}) do
    sizes = MapSet.to_list(sheet) |> find_sheet_size()
    {first_half, second_half} = divide_sheet(sheet, {plane, line})
    offsets = calc_offsets(sizes, plane, line)

    folded_half = second_half |> Enum.map(fn dot -> apply_fold(dot, plane, offsets) end)
    MapSet.new(first_half ++ folded_half)
  end

  defp divide_sheet(sheet, {plane, line}) do
    sheet |> MapSet.to_list() |> Enum.reduce({[], []}, fn {x, y}, {first_half, second_half} ->
      case plane do
        "x" when x > line -> {first_half, [{x, y} | second_half]}
        "x" when x < line -> {[{x, y} | first_half], second_half}
        "y" when y > line -> {first_half, [{x, y} | second_half]}
        "y" when y < line -> {[{x, y} | first_half], second_half}
        _ -> {first_half, second_half}
      end
    end)
  end

  defp apply_fold({x, y}, plane, {x_size, y_size}) do
    case plane do
      "x" -> { x_size - x, y }
      "y" -> { x, y_size - y }
    end
  end

  defp paint(sheet) do
    dots = MapSet.to_list(sheet)
    {x_size, y_size} = dots |> find_sheet_size()
    canvas = 0..y_size
    |> Enum.map(fn _ ->
      0..x_size
      |> Enum.map(fn _ -> " " end)
    end)

     image = dots
    |> Enum.reduce(canvas, fn {x, y}, canvas ->
      inner_list = Enum.at(canvas, y)
      canvas |> List.replace_at(y, List.replace_at(inner_list, x, "0"))
    end)
    IO.puts ""
    image |> Enum.each(fn row -> IO.puts(Enum.join(row, "")) end)
    # image # return the image for testing
  end

  defp calc_offsets({x_size, y_size}, plane, line) do
    case plane do
      "x" when div(x_size, line) == x_size/line -> {x_size, y_size}
      "x"  -> {x_size + 1, y_size}
      "y" when div(y_size, line) == y_size/line -> {x_size, y_size}
      "y"  -> {x_size, y_size + 1}
    end
  end
end
