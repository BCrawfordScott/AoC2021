defmodule Input do
  def read(filename) do
    {:ok, input} = File.read(filename)
    input
   end

  def to_array(filename) do
    filename
    |> read
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
  end
end
