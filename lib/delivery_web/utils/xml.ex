defmodule DeliveryWeb.Utils.XML do
  alias DeliveryWeb.Utils.Renderer
  @behaviour Renderer

  def p(next, _) do
    ["<p>", next.(), "</p>"]
  end

  def table(next, _) do
    ["<table>", next.(), "</table>"]
  end

  def thead(next, _) do
    next.()
  end

  def tbody(next, _) do
    next.()
  end

  def tr(next, _) do
    ["<tr>", next.(), "</tr>"]
  end

  def td(next, _) do
    ["<td>", next.(), "</td>"]
  end

  def th(next, _) do
    ["<th>", next.(), "</th>"]
  end

  def image(_, %{data: %{src: src}}) do
    ["<image src=\"", src, "\"/>"]
  end

  def youtube(_, %{data: %{src: src}}) do
    ["<youtube src=\"", src, "\"/>"]
  end

  def ul(next, _) do
    ["<ul>", next.(), "</ul>"]
  end

  def ol(next, _) do
    ["<ol>", next.(), "</ol>"]
  end

  def li(next, _) do
    ["<li>", next.(), "</li>"]
  end

  def header(next) do
    ["<section><title>", next.(), "</title><body><p></p></body></section"]
  end

  def h1(next, _) do
    header(next)
  end

  def h2(next, _) do
    header(next)
  end

  def h3(next, _) do
    header(next)
  end

  def h4(next, _) do
    header(next)
  end

  def h5(next, _) do
    header(next)
  end

  def h6(next, _) do
    header(next)
  end

  def audio(_, %{data: %{src: src}}) do
    ["<audio src=\"", src, "\"/>"]
  end

  def blockquote(next, _) do
    ["<quote>", next.(), "</quote>"]
  end

  def a(next, _) do
    ["<p>", next.(), "</p>"]
  end

  def definition(next, _) do
    ["<p>", next.(), "</p>"]
  end

  def text(%{text: text, marks: marks}) do
    wrap_marks(text, marks)
  end

  def document(next, %{data: %{id: id, title: title}}) do
    [
      "<workbook_page id=\"#{id}\"><head><title>#{title}</title></head><body>",
      next.(),
      "</body></workbook_page>"
    ]
  end

  def wrap_marks(text, marks) do
    IO.puts("wrap-marks")
    IO.inspect(text)
    IO.inspect(marks)

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
    |> Enum.reduce(
      text,
      fn %{"type" => m}, t ->
        "<" <> Map.get(map, m) <> ">" <> t <> "</" <> Map.get(map, m) <> ">"
      end
    )
  end
end
