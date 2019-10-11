defmodule DeliveryWeb.Utils.Markdown do

  def to_markdown(%{"object" => "block", "type" => "paragraph", "nodes" => nodes}) do
    to_markdown(nodes) <> "\n\n"
  end

  def to_markdown(%{"object" => "block", "type" => "heading-one", "nodes" => nodes}) do
    "# " <> to_markdown(nodes) <> "\n\n"
  end

  def to_markdown(%{"object" => "block", "type" => "heading-two", "nodes" => nodes}) do
    "## " <> to_markdown(nodes) <> "\n\n"
  end

  def to_markdown(%{"object" => "block", "type" => "heading-three", "nodes" => nodes}) do
    "### " <> to_markdown(nodes) <> "\n\n"
  end

  def to_markdown(%{"object" => "block", "type" => "heading-four", "nodes" => nodes}) do
    "#### " <> to_markdown(nodes) <> "\n\n"
  end

  def to_markdown(%{"object" => "block", "type" => "heading-five", "nodes" => nodes}) do
    "##### " <> to_markdown(nodes) <> "\n\n"
  end

  def to_markdown(%{"object" => "block", "type" => "heading-six", "nodes" => nodes}) do
    "###### " <> to_markdown(nodes) <> "\n\n"
  end

  def to_markdown(%{"object" => "text", "text" => text, "marks" => marks}) do
    IO.puts "text-marks"
    wrap_marks(text, marks)
  end

  def to_markdown(%{"object" => "text", "text" => text}) do
    IO.puts "text"
    text
  end

  def to_markdown(%{"object" => "block"}) do
    IO.puts "block empty"
    ""
  end

  def to_markdown(nodes) when is_list(nodes) do
    IO.puts "list"
    Enum.map(nodes, fn n -> to_markdown(n) end)
      |> Enum.join("")
  end

  def to_markdown(_) do
    IO.puts "empty"
    ""
  end

  def wrap_marks(text, marks) do
    IO.puts "wrap-marks"
    IO.inspect text
    IO.inspect marks
    map = %{
      "sub" => "",
      "sup" => "",
      "bold" => "**",
      "underline" => "u",
      "code" => "`",
      "italic" => "*",
      "strikethrough" => "~~",
      "mark" => ""
    }
    Enum.reverse(marks)
      |> Enum.reduce(text,
        fn %{"type" => m}, t ->
          Map.get(map, m) <> t <>  Map.get(map, m)
        end)
  end

end
