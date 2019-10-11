defmodule DeliveryWeb.Utils.Text do

  def to_text(%{"object" => "block", "type" => "paragraph", "nodes" => nodes}) do
    to_text(nodes) <> "\n\n"
  end

  def to_text(%{"object" => "block", "type" => "heading-one", "nodes" => nodes}) do
    to_text(nodes) <> "\n\n"
  end

  def to_text(%{"object" => "block", "type" => "heading-two", "nodes" => nodes}) do
    to_text(nodes) <> "\n\n"
  end

  def to_text(%{"object" => "block", "type" => "heading-three", "nodes" => nodes}) do
    to_text(nodes) <> "\n\n"
  end

  def to_text(%{"object" => "block", "type" => "heading-four", "nodes" => nodes}) do
    to_text(nodes) <> "\n\n"
  end

  def to_text(%{"object" => "block", "type" => "heading-five", "nodes" => nodes}) do
    to_text(nodes) <> "\n\n"
  end

  def to_text(%{"object" => "block", "type" => "heading-six", "nodes" => nodes}) do
    to_text(nodes) <> "\n\n"
  end

  def to_text(%{"object" => "text", "text" => text}) do
    IO.puts "text"
    text
  end

  def to_text(%{"object" => "block"}) do
    IO.puts "block empty"
    ""
  end

  def to_text(nodes) when is_list(nodes) do
    IO.puts "list"
    Enum.map(nodes, fn n -> to_text(n) end)
      |> Enum.join("")
  end

  def to_text(_) do
    IO.puts "empty"
    ""
  end

end
