defmodule Aoc2021.Day16Test do
  use ExUnit.Case
  doctest Aoc2021.Day16

  import Aoc2021.Day16, only: [
    part1: 1,
    part2: 1,
  ]

  @test_file Path.dirname(__ENV__.file) <> "/test.txt"

  test "has an input file" do
    assert(File.exists?(File.cwd! <> "/lib/aoc_2021/day16/input.txt"))
  end

  test "part 1 delivers the right output" do
    assert(part1(@test_file) == :none)
  end

  test "part 2 delivers the right output" do
    assert(part2(@test_file) == :none)
  end
end
