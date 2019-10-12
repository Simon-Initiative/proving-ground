defmodule DeliveryWeb.Utils.HTML do

  def to_html(%{"object" => "block", "type" => "paragraph", "nodes" => nodes}) do
    "<p>" <> to_html(nodes) <> "</p>\n"
  end

  def to_html(%{"object" => "block", "type" => "table", "nodes" => nodes}) do
    """
    <table class="ui compact celled table">
      #{to_html(nodes)}
    </table>
    """
  end

  def to_html(%{"object" => "block", "type" => "thead", "nodes" => nodes}) do
    """
    <thead>
      #{to_html(nodes)}
    </thead>
    """
  end

  def to_html(%{"object" => "block", "type" => "tbody", "nodes" => nodes}) do
    """
    <tbody>
      #{to_html(nodes)}
    </tbody>
    """
  end

  def to_html(%{"object" => "block", "type" => "tr", "nodes" => nodes}) do
    """
    <tr>
      #{to_html(nodes)}
    </tr>
    """
  end

  def to_html(%{"object" => "block", "type" => "td", "nodes" => nodes}) do
    """
    <td>
      #{to_html(nodes)}
    </td>
    """
  end

  def to_html(%{"object" => "block", "type" => "th", "nodes" => nodes}) do
    """
    <th>
      #{to_html(nodes)}
    </th>
    """
  end

  def to_html(%{"object" => "block",
    "data" => %{"src" => src, "height" => height, "width" => width},
    "type" => "image"}) do
    """
    <img style="display: block; margin-left: auto; margin-right: auto;" src=#{src} height=#{height} width=#{width}/>
    """
  end

  def to_html(%{"object" => "block",
    "type" => "code", "nodes" => nodes}) do
    """
    <div class="ui segment"
      style="font-family: Menlo, Monaco, Courier New, monospace;
        padding: 9px;
        margin-left: 20px;
        margin-right: 20px;
        border: 1px solid #eeeeee;
        border-left: 2px solid darkblue;
        min-height: 60px;
        position: relative;">
      #{to_html(nodes)}
    </div>
    """
  end

  def to_html(%{"object" => "block",
    "type" => "code_line", "nodes" => nodes}) do
    """
    <div>#{to_html(nodes)}</div>
    """
  end

  def to_html(%{"object" => "block",
    "data" => %{"src" => src},
    "type" => "youtube"}) do
    IO.puts "p"
    """
    <iframe
      width="640"
      height="476"
      src="https://www.youtube.com/embed/#{src}"
      frameBorder="0"
      style="display: block; margin-left: auto; margin-right: auto;"
    />
    """
  end

  def to_html(%{"object" => "block", "type" => "heading-one", "nodes" => nodes}) do
    "<h1>" <> to_html(nodes) <> "</h1>\n"
  end

  def to_html(%{"object" => "block", "type" => "heading-two", "nodes" => nodes}) do
    "<h2>" <> to_html(nodes) <> "</h2>\n"
  end

  def to_html(%{"object" => "block", "type" => "heading-three", "nodes" => nodes}) do
    "<h3>" <> to_html(nodes) <> "</h3>\n"
  end

  def to_html(%{"object" => "block", "type" => "heading-four", "nodes" => nodes}) do
    "<h4>" <> to_html(nodes) <> "</h4>\n"
  end

  def to_html(%{"object" => "block", "type" => "heading-five", "nodes" => nodes}) do
    "<h5>" <> to_html(nodes) <> "</h5>\n"
  end

  def to_html(%{"object" => "block", "type" => "heading-six", "nodes" => nodes}) do
    "<h6>" <> to_html(nodes) <> "</h6>\n"
  end

  def to_html(%{"object" => "text", "text" => text, "marks" => marks}) do
    IO.puts "text-marks"
    wrap_marks(text, marks)
  end

  def to_html(%{"object" => "text", "text" => text}) do
    IO.puts "text"
    text
  end

  def to_html(%{"object" => "block"}) do
    IO.puts "block empty"
    ""
  end

  def to_html(nodes) when is_list(nodes) do
    IO.puts "list"
    Enum.map(nodes, fn n -> to_html(n) end)
      |> Enum.join("\n")
  end

  def to_html(_) do
    IO.puts "empty"
    ""
  end

  def wrap_marks(text, marks) do
    IO.puts "wrap-marks"
    IO.inspect text
    IO.inspect marks
    map = %{
      "sub" => "sub",
      "sup" => "sup",
      "bold" => "strong",
      "underline" => "u",
      "code" => "code",
      "italic" => "em",
      "strikethrough" => "strike",
      "mark" => "mark"
    }
    Enum.reverse(marks)
      |> Enum.reduce(text,
        fn %{"type" => m}, t ->
          "<" <> Map.get(map, m) <> ">" <> t <> "</" <> Map.get(map, m) <> ">"
        end)
  end

end
