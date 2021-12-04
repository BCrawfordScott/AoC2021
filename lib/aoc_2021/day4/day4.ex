defmodule Aoc2021.Day4 do

  @input_file Path.dirname(__ENV__.file) <> "/input.txt"
  @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  def test(:part_one), do: part1(@test_file)
  def test(:part_two), do: part2(@test_file)

  def part1, do: part1(@input_file)
  def part1(path) do
    path
    |> parse_input()
    |> play
  end

  def part2, do: part2(@input_file)
  def part2(path) do
    path
    |> parse_input()
    |> play(:last)
  end

  defp check_lanes(board_lanes) do
    board_lanes
    |> Enum.any?(fn lane ->
      Enum.all?(lane, fn char -> char == "X" end)
    end)
  end

  defp find_winner(boards) do
    boards
    |> Enum.find(:none, fn board -> is_winner?(board) end)
  end

  defp is_winner?(board) do
    board_rows = board |> String.split("\n", trim: true) |> Enum.map(&(String.split(&1, " ", trim: true)))
    board_columns = board_rows |> Enum.zip |> Enum.map(&Tuple.to_list/1)

    check_lanes(board_rows) || check_lanes(board_columns)
  end

  defp mark_boards(number, boards) do
    boards |> Enum.map(fn board ->
      String.split(board, "\n")
      |> Enum.map(&(String.split(&1, " ")))
      |> Enum.map(fn row -> Enum.map(row, fn el -> if el == number, do: "X", else: el end) |> Enum.join(" ") end)
      |> Enum.join("\n")
    end)
  end

  defp parse_input(path) do
    [ numbers | boards] = path |> Input.read |> String.split("\n\n", trim: true)

    {String.split(numbers, ",", trim: true), boards}
  end

  defp play(inputs), do: play(inputs, :first)
  defp play({numbers, boards}, :first) do
    [current_number | next_numbers] = numbers
    marked_boards = mark_boards(current_number, boards)
    case find_winner(marked_boards) do
      :none -> play({next_numbers, marked_boards})
      board -> process_board(board, current_number)
    end
  end
  defp play({numbers, boards}, :last) when length(boards) == 1, do: play({numbers, boards}, :first)
  defp play({numbers, boards}, :last) do
    [current_number | next_numbers] = numbers
    marked_boards = mark_boards(current_number, boards)
    case find_winner(marked_boards) do
      :none -> play({next_numbers, marked_boards}, :last)
      board -> play({numbers, remove_board(board, marked_boards)}, :last)
    end
  end

  defp process_board(board, number) do
    (remainders(board) |> Enum.sum) * String.to_integer(number)
  end

  defp remainders(board) do
    board
    |> String.replace(~r/[\nX]/, " ")
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp remove_board(board, board_list) do
    List.delete(board_list, board)
  end
end
