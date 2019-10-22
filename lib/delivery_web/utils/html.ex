defmodule DeliveryWeb.Utils.HTML do

  def label(text) do
    """
    <span style="text-transform: uppercase; color: lightgray;">#{text}</span>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "paragraph", "nodes" => nodes}) do
    "<p>" <> to_html(context, nodes) <> "</p>\n"

  end

  def to_html(context, %{"object" => "block", "type" => "variant", "nodes" => nodes}) do
    to_html(context, nodes)

  end

  def to_html(context, %{"object" => "inline", "data" => %{"href" => href}, "type" => "link", "nodes" => nodes}) do
    """
    <a href="#{href}">#{to_html(context, nodes)}</a>
    """
  end

  def to_html(context, %{"object" => "inline", "data" => %{"definition" => definition}, "type" => "definition", "nodes" => nodes}) do
    """
    <span class="definition" style="color: green;" data-title="Definition" data-content="#{definition}">#{to_html(context, nodes)}</span>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "choice", "nodes" => nodes}) do
    """
    <div class="field">
      <div class="ui radio checkbox">
        <input type="radio" name="fruit" tabindex="0" class="hidden">
        <label>#{to_html(context, nodes)}</label>
      </div>
    </div>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "choice_feedback", "nodes" => nodes}) do
    to_html(context, nodes)
  end

  def to_html(context, %{"object" => "block", "type" => "stem", "nodes" => nodes}) do
    to_html(context, nodes)
  end

  def to_html(context, %{"object" => "block", "type" => "list-item", "nodes" => nodes}) do
    "<li>" <> to_html(context, nodes) <> "</li>\n"
  end

  def to_html(context, %{"object" => "block", "type" => "list-item-child", "nodes" => nodes}) do
    to_html(context, nodes)
  end

  def to_html(context, %{"object" => "block", "type" => "ordered-list", "nodes" => nodes}) do
    "<ol>" <> to_html(context, nodes) <> "</ol>\n"
  end

  def to_html(context, %{"object" => "block", "type" => "unordered-list", "nodes" => nodes}) do
    "<ul>" <> to_html(context, nodes) <> "</ul>\n"
  end

  def to_html(%{:preview => false, :user => user},
    %{"object" => "block", "type" => "example", "nodes" => nodes}) do

    to_html(%{:preview => false, :user => user}, Enum.at(nodes, rem(user.id, 2)))
  end

  def to_html(%{:preview => true, :user => user},
    %{"object" => "block", "type" => "example", "nodes" => nodes}) do

    a = to_html(%{:preview => true, :user => user}, Enum.at(nodes, 0))
    b = to_html(%{:preview => true, :user => user}, Enum.at(nodes, 1))
    """
    <table class="ui table">
      <tbody>
        <tr><td>Variant A</td><td>#{a}</td></tr>
        <tr><td>Variant B</td><td>#{b}</td></tr>
      </tbody>
    </table>
    """
  end


  def to_html(context, %{"object" => "block", "type" => "multiple_choice", "nodes" => nodes}) do
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
      #{stem(context, nodes)}
      <div class="ui form">
        <div class="grouped fields">
          #{choices(context, nodes)}
        </div>
      </div>
      <button class="ui button mini primary">Submit</button>
    </div>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "math", "nodes" => nodes}) do
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
      #{to_html(context, nodes)}
    </div>
    """
  end

  def to_html(_context, %{"object" => "block", "type" => "math_line", "nodes" => nodes}) do
    Map.get(nodes |> hd, "text")
  end

  def to_html(context, %{"object" => "block", "type" => "table", "nodes" => nodes}) do
    """
    <table class="ui compact celled table">
      #{to_html(context, nodes)}
    </table>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "thead", "nodes" => nodes}) do
    """
    <thead>
      #{to_html(context, nodes)}
    </thead>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "tbody", "nodes" => nodes}) do
    """
    <tbody>
      #{to_html(context, nodes)}
    </tbody>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "tr", "nodes" => nodes}) do
    """
    <tr>
      #{to_html(context, nodes)}
    </tr>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "td", "nodes" => nodes}) do
    """
    <td>
      #{to_html(context, nodes)}
    </td>
    """
  end

  def to_html(context, %{"object" => "block", "type" => "th", "nodes" => nodes}) do
    """
    <th>
      #{to_html(context, nodes)}
    </th>
    """
  end

  def to_html(_context, %{"object" => "block",
    "data" => %{"src" => src, "height" => height, "width" => width},
    "type" => "image"}) do
    IO.puts "html image"
    """
    <img style="display: block; max-height: 500px; margin-left: auto; margin-right: auto;" src="#{src}" height=#{height} width=#{width}/>
    """
  end

  def to_html(_context, %{"object" => "block",
    "data" => %{"src" => src },
    "type" => "image"}) do
    IO.puts "html image"
    """
    <img style="display: block; max-height: 500px; margin-left: auto; margin-right: auto;" src="#{src}"/>
    """
  end

  def to_html(context, %{"object" => "block",
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
      #{to_html(context, nodes)}
    </div>
    """
  end

  def to_html(context, %{"object" => "block",
    "type" => "code_line", "nodes" => nodes}) do
    """
    <div>#{to_html(context, nodes)}</div>
    """
  end

  def to_html(_context, %{"object" => "block",
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

  def to_html(context, %{"object" => "block", "type" => "heading-one", "nodes" => nodes}) do
    "<h1>" <> to_html(context, nodes) <> "</h1>\n"
  end

  def to_html(context, %{"object" => "block", "type" => "heading-two", "nodes" => nodes}) do
    "<h2>" <> to_html(context, nodes) <> "</h2>\n"
  end

  def to_html(context, %{"object" => "block", "type" => "heading-three", "nodes" => nodes}) do
    "<h3>" <> to_html(context, nodes) <> "</h3>\n"
  end

  def to_html(context, %{"object" => "block", "type" => "heading-four", "nodes" => nodes}) do
    "<h4>" <> to_html(context, nodes) <> "</h4>\n"
  end

  def to_html(context, %{"object" => "block", "type" => "heading-five", "nodes" => nodes}) do
    "<h5>" <> to_html(context, nodes) <> "</h5>\n"
  end

  def to_html(context, %{"object" => "block", "type" => "heading-six", "nodes" => nodes}) do
    "<h6>" <> to_html(context, nodes) <> "</h6>\n"
  end

  def to_html(_context, %{"object" => "text", "text" => text, "marks" => marks}) do
    wrap_marks(text, marks)
  end

  def to_html(_context, %{"object" => "text", "text" => text}) do
    text
  end

  def to_html(_context, %{"object" => "block", "type" => type}) do
    IO.puts "unsupported block: " <> type
    ""
  end

  def to_html(context, nodes) when is_list(nodes) do
    Enum.map(nodes, fn n -> to_html(context, n) end)
      |> Enum.join("\n")
  end

  def to_html(_, _) do
    IO.puts "html other"
    ""
  end

  def stem(context, nodes) do
    item = Enum.filter(nodes, fn n -> Map.get(n, "type") == "stem" end)
      |> hd
    to_html(context, item)
  end

  def choices(context, nodes) do
    Enum.filter(nodes, fn n -> Map.get(n, "type") == "choice_feedback" end)
      |> Enum.map(fn c -> to_html(context, c) end)
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
