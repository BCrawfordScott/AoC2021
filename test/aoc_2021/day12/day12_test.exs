defmodule Aoc2021.Day12Test do
  use ExUnit.Case
  doctest Aoc2021.Day12

  import Aoc2021.Day12, only: [
    part1: 1,
    part2: 1,
  ]

  @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  test "has an input file" do
    assert(File.exists?(File.cwd! <> "/lib/aoc_2021/day12/input.txt"))
  end

  test "part 1 delivers the right output" do
    assert(part1(@test_file) == 226)
  end

  test "part 2 delivers the right output" do
    assert(part2(@test_file) == 3509)
  end
end
