defmodule Aoc2021 do
  @moduledoc """
  Compiled solutions for Advent of Code 2021: https://adventofcode.com/2021
  """

  alias Aoc2021.Day1, as: Day1
  alias Aoc2021.Day2, as: Day2
  alias Aoc2021.Day3, as: Day3
  alias Aoc2021.Day4, as: Day4

  def solve do
    # Day 1
    IO.puts "Day1, part 1: #{Day1.refactor_part1()}"
    IO.puts "Day1, part 2: #{Day1.refactor_part2()}"
    IO.puts ""
    # Day 2
    IO.puts "Day2, part 1: #{Day2.part1()}"
    IO.puts "Day2, part 2: #{Day2.part2()}"
    IO.puts ""
    # Day 3
    IO.puts "Day3, part 1: #{Day3.part1()}"
    IO.puts "Day3, part 2: #{Day3.part2()}"
    IO.puts ""
    # Day 4
    IO.puts "Day4, part 1: #{Day4.part1()}"
    IO.puts "Day4, part 2: #{Day4.part2()}"
    IO.puts ""
  end
end
