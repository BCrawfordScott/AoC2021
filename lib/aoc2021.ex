defmodule Aoc2021 do
  @moduledoc """
  Compiled solutions for Advent of Code 2021: https://adventofcode.com/2021
  """

  alias Aoc2021.Day1, as: Day1
  alias Aoc2021.Day2, as: Day2

  def solve do
    # Day 1
    IO.puts "Day1, part 1: #{Day1.refactor_part1()}"
    IO.puts "Day1, part 2: #{Day1.refactor_part2()}"
    # Day 2
    IO.puts "Day2, part 1: #{Day2.part1()}"
    IO.puts "Day2, part 2: #{Day2.part2()}"
  end
end
