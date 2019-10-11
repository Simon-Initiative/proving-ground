defmodule DeliveryWeb.Utils.XML do

  def to_xml(%{"object" => "block", "type" => "paragraph", "nodes" => nodes}) do
    IO.puts "p"
    "<p>" <> to_xml(nodes) <> "</p>\n"
  end

  def to_xml(%{"object" => "block", "type" => "heading-one", "nodes" => nodes}) do
    "<section><title>" <> to_xml(nodes) <> "</title><body></body></section>\n"
  end

  def to_xml(%{"object" => "block", "type" => "heading-two", "nodes" => nodes}) do
    "<section><title>" <> to_xml(nodes) <> "</title><body></body></section>\n"
  end

  def to_xml(%{"object" => "block", "type" => "heading-three", "nodes" => nodes}) do
    "<section><title>" <> to_xml(nodes) <> "</title><body></body></section>\n"
  end

  def to_xml(%{"object" => "block", "type" => "heading-four", "nodes" => nodes}) do
    "<section><title>" <> to_xml(nodes) <> "</title><body></body></section>\n"
  end

  def to_xml(%{"object" => "block", "type" => "heading-five", "nodes" => nodes}) do
    "<section><title>" <> to_xml(nodes) <> "</title><body></body></section>\n"
  end

  def to_xml(%{"object" => "block", "type" => "heading-six", "nodes" => nodes}) do
    "<section><title>" <> to_xml(nodes) <> "</title><body></body></section>\n"
  end

  def to_xml(%{"object" => "text", "text" => text, "marks" => marks}) do
    IO.puts "text-marks"
    wrap_marks(text, marks)
  end

  def to_xml(%{"object" => "text", "text" => text}) do
    IO.puts "text"
    text
  end

  def to_xml(%{"object" => "block"}) do
    IO.puts "block empty"
    ""
  end

  def to_xml(nodes) when is_list(nodes) do
    IO.puts "list"
    Enum.map(nodes, fn n -> to_xml(n) end)
      |> Enum.join("\n")
  end

  def to_xml(_) do
    IO.puts "empty"
    ""
  end


  def to(nodes) do
    """
    <workbook_page id="some_id">
      <head>
        <title>This is the title</title>
      </head>
      <body>
    """ <> to_xml(nodes) <>
    """
      </body>
    </workbook_page>
    """
  end

  def wrap_marks(text, marks) do
    IO.puts "wrap-marks"
    IO.inspect text
    IO.inspect marks
    map = %{
      "sub" => "sub",
      "sup" => "sup",
      "bold" => "em",
      "underline" => "",
      "code" => "code",
      "italic" => "em",
      "strikethrough" => "em",
      "mark" => "em"
    }
    Enum.reverse(marks)
      |> Enum.reduce(text,
        fn %{"type" => m}, t ->
          "<" <> Map.get(map, m) <> ">" <> t <> "</" <> Map.get(map, m) <> ">"
        end)
  end

end
