defmodule Aoc2021 do
  @moduledoc """
  Compiled solutions for Advent of Code 2021: https://adventofcode.com/2021
  """

  alias Aoc2021.Day1
  alias Aoc2021.Day2
  alias Aoc2021.Day3
  alias Aoc2021.Day4
  alias Aoc2021.Day5

  def solve do
    # Day 1
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 1,", :light_yellow, " part",  :light_white, " 1: ", :light_green, "#{Day1.refactor_part1()}"])
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 1,", :light_yellow, " part",  :light_white, " 2: ", :light_green, "#{Day1.refactor_part2()}"])
    IO.puts ""
    # Day 2
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 2,", :light_yellow, " part",  :light_white, " 1: ", :light_green, "#{Day2.part1()}"])
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 2,", :light_yellow, " part",  :light_white, " 2: ", :light_green, "#{Day2.part2()}"])
    IO.puts ""
    # Day 3
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 3,", :light_yellow, " part",  :light_white, " 1: ", :light_green, "#{Day3.part1()}"])
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 3,", :light_yellow, " part",  :light_white, " 2: ", :light_green, "#{Day3.part2()}"])
    IO.puts ""
    # Day 4
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 4,", :light_yellow, " part",  :light_white, " 1: ", :light_green, "#{Day4.part1()}"])
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 4,", :light_yellow, " part",  :light_white, " 2: ", :light_green, "#{Day4.part2()}"])
    IO.puts ""
    # Day 5
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 5,", :light_yellow, " part",  :light_white, " 1: ", :light_green, "#{Day5.part1()}"])
    IO.puts IO.ANSI.format([:light_cyan, "Day",  :light_white, " 5,", :light_yellow, " part",  :light_white, " 2: ", :light_green, "#{Day5.part2()}"])
    IO.puts ""
  end
end
