defmodule Aoc2021.Day6Test do
  use ExUnit.Case
  doctest Aoc2021.Day6

  import Aoc2021.Day6, only: [
    part1: 1,
    part2: 1,
  ]

  @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  test "has an input file" do
    assert(File.exists?(File.cwd! <> "/lib/aoc_2021/day6/input.txt"))
  end

  test "part 1 delivers the right output" do
    assert(part1(@test_file) == 5934)
  end

  test "part 2 delivers the right output" do
    assert(part2(@test_file) == 26984457539)
  end
end
