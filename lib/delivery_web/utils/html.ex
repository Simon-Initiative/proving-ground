defmodule DeliveryWeb.Utils.HTML do

  def label(text) do
    """
    <span style="text-transform: uppercase; color: lightgray;">#{text}</span>
    """
  end

  def to_html(%{"object" => "block", "type" => "paragraph", "nodes" => nodes}) do
    "<p>" <> to_html(nodes) <> "</p>\n"

  end

  def to_html(%{"object" => "inline", "data" => %{"href" => href}, "type" => "link", "nodes" => nodes}) do
    """
    <a href="#{href}">#{to_html(nodes)}</a>
    """
  end

  def to_html(%{"object" => "inline", "data" => %{"definition" => definition}, "type" => "definition", "nodes" => nodes}) do
    """
    <span class="definition" style="color: green;" data-title="Definition" data-content="#{definition}">#{to_html(nodes)}</span>
    """
  end

  def to_html(%{"object" => "block", "type" => "choice", "nodes" => nodes}) do
    """
    <div class="field">
      <div class="ui radio checkbox">
        <input type="radio" name="fruit" tabindex="0" class="hidden">
        <label>#{to_html(nodes)}</label>
      </div>
    </div>
    """
  end

  def to_html(%{"object" => "block", "type" => "choice_feedback", "nodes" => nodes}) do
    to_html(nodes)
  end

  def to_html(%{"object" => "block", "type" => "stem", "nodes" => nodes}) do
    to_html(nodes)
  end

  def to_html(%{"object" => "block", "type" => "list-item", "nodes" => nodes}) do
    "<li>" <> to_html(nodes) <> "</li>\n"
  end

  def to_html(%{"object" => "block", "type" => "list-item-child", "nodes" => nodes}) do
    to_html(nodes)
  end

  def to_html(%{"object" => "block", "type" => "ordered-list", "nodes" => nodes}) do
    "<ol>" <> to_html(nodes) <> "</ol>\n"
  end

  def to_html(%{"object" => "block", "type" => "unordered-list", "nodes" => nodes}) do
    "<ul>" <> to_html(nodes) <> "</ul>\n"
  end

  def to_html(%{"object" => "block", "type" => "example", "nodes" => nodes}) do
    """
    <div style="margin-left: 20px;
                margin-right: 20px;
                padding: 9px;
                border: 1px solid #eeeeee;
                border-left: 2px solid red;
                position: relative;">
      <div
        style="position: absolute; top: 5px; right: 15px;"
      >
        #{label("Example")}
      </div>
      #{to_html(nodes)}
    </div>
    """
  end


  def to_html(%{"object" => "block", "type" => "multiple_choice", "nodes" => nodes}) do
    """
    <div style="margin-left: 30px;
                margin-right: 10px;
                padding: 15px;
                border: 1px solid #eeeeee;
                border-left: 2px solid darkblue;
                position: relative;">
      <div
        style="position: absolute; top: 5px; right: 15px;"
      >
        #{label("Multiple Choice")}
      </div>
      #{stem(nodes)}
      <div class="ui form">
        <div class="grouped fields">
          #{choices(nodes)}
        </div>
      </div>
      <button class="ui button mini primary">Submit</button>
    </div>
    """
  end

  def to_html(%{"object" => "block", "type" => "math", "nodes" => nodes}) do
    """
    <div style="margin-left: 20px;
                margin-right: 20px;
                padding: 9px;
                border: 1px solid #eeeeee;
                border-left: 2px solid darkblue;
                min-height: 60px;
                font-family: Menlo, Monaco, Courier New, monospace;
                position: relative;">
      <div
        style="position: absolute; top: 5px; right: 15px;"
      >
        #{label("Math")}
      </div>
      #{to_html(nodes)}
    </div>
    """
  end

  def to_html(%{"object" => "block", "type" => "math_line", "nodes" => nodes}) do
    Map.get(nodes |> hd, "text")
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
    IO.puts "html image"
    """
    <img style="display: block; max-height: 500px; margin-left: auto; margin-right: auto;" src="#{src}" height=#{height} width=#{width}/>
    """
  end

  def to_html(%{"object" => "block",
    "data" => %{"src" => src },
    "type" => "image"}) do
    IO.puts "html image"
    """
    <img style="display: block; max-height: 500px; margin-left: auto; margin-right: auto;" src="#{src}"/>
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

    """
    <iframe
      id="#{src}"
      width="640"
      height="476"
      src="https://www.youtube.com/embed/#{src}"
      frameBorder="0"
      style="display: block; margin-left: auto; margin-right: auto;"
    ></iframe>
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
    wrap_marks(text, marks)
  end

  def to_html(%{"object" => "text", "text" => text}) do
    text
  end

  def to_html(%{"object" => "block"}) do
    IO.puts "html unkown"
    ""
  end

  def to_html(nodes) when is_list(nodes) do
    Enum.map(nodes, fn n -> to_html(n) end)
      |> Enum.join("\n")
  end

  def to_html(_) do
    IO.puts "html other"
    ""
  end


  def stem(nodes) do
    Enum.filter(nodes, fn n -> Map.get(n, "type") == "stem" end)
      |> hd
      |> to_html()
  end

  def choices(nodes) do
    Enum.filter(nodes, fn n -> Map.get(n, "type") == "choice_feedback" end)
      |> Enum.map(fn c -> to_html(c) end)
      |> Enum.join("\n")
  end

  def wrap_marks(text, marks) do
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
