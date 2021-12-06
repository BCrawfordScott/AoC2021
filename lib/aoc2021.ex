defmodule Aoc2021 do
  @moduledoc """
  Compiled solutions for Advent of Code 2021: https://adventofcode.com/2021
  """

  def solve do
    run()
  end

  defp run do
    1..25
    |> Enum.each(fn day ->
      {module, _} = Code.eval_string("#{__MODULE__}.Day#{day}")
      case Code.ensure_loaded(module) do
        {:module, loaded_module} -> 1..2 |> Enum.each(fn part -> solution_for(loaded_module, day, part) end)
        {:error, _} -> IO.puts IO.ANSI.format([:light_red, "Solutions for Day#{day} not yet available."])
      end
      IO.puts ""
    end)
  end

  defp solution_for(module, day, part) do
    case function_exported?(module, String.to_atom("part#{part}"), 0) do
      true ->
        solution = apply(module, String.to_atom("part#{part}"), [])
        IO.puts IO.ANSI.format([:black_background, :light_cyan, "Day",  :light_white, " #{day},", :light_yellow, " part",  :light_white, " #{part}: ", :light_green, "#{solution}"])
      false -> IO.puts IO.ANSI.format([:light_red, "Solutions for Day #{day} part #{part} not yet available."])
    end
  end
end
