defmodule InputStream do
  def build(path), do: File.stream!(path)
  # def build(path, opts), do: File.stream!(path)
  def clean(stream) do
    stream
    |> Stream.map(&(String.replace(&1, "\r", "")))
    |> Stream.map(&(String.replace(&1, "\n", "")))
  end

  def to_list(path) do
    path
    |> build()
    |> clean()
    |> Enum.to_list
  end

end
