defmodule DeliveryWeb.Utils.XML do
  alias DeliveryWeb.Utils.Renderer
  @behaviour Renderer

  def p(next, _) do
    ["<p>", next.(), "</p>\n"]
  end

  def table(next, _) do
    ["<table>", next.(), "</table>\n"]
  end

  def caption(next, _) do
    ["<caption>", next.(), "</caption>\n"]
  end

  def thead(next, _) do
    next.()
  end

  def tbody(next, _) do
    next.()
  end

  def tfoot(next, _) do
    next.()
  end

  def tr(next, _) do
    ["<tr>", next.(), "</tr>\n"]
  end

  def td(next, _) do
    ["<td>", next.(), "</td>\n"]
  end

  def th(next, _) do
    ["<th>", next.(), "</th>\n"]
  end

  def image(_, %{data: %{"src" => src}}) do
    ["<image src=\"", src, "\"/>\n"]
  end

  def youtube(_, %{data: %{"src" => src}}) do
    ["<youtube src=\"", src, "\"/>\n"]
  end

  def ul(next, _) do
    ["<ul>", next.(), "</ul>\n"]
  end

  def ol(next, _) do
    ["<ol>", next.(), "</ol>\n"]
  end

  def li(next, _) do
    ["<li>", next.(), "</li>\n"]
  end

  def header(next) do
    ["<section><title>", next.(), "</title><body><p></p></body></section>\n"]
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

  def audio(_, %{data: %{"src" => src}}) do
    ["<audio src=\"", src, "\"/>\n"]
  end

  def blockquote(next, _) do
    ["<quote>", next.(), "</quote>\n"]
  end

  def codeblock(next, %{data: %{"syntax" => syntax}}) do
    ["<codeblock syntax=\"#{syntax}\">", next.(), "</codeblock>\n"]
  end

  def codeline(_, %{nodes: nodes}) do
    Enum.map(nodes, fn n -> n.text end)
  end

  def a(next, %{data: %{"href" => href}}) do
    ["<link href=\"#{escape_xml(href)}\">", next.(), "</link>\n"]
  end

  def definition(next, _) do
    ["<extra>", next.(), "</extra>\n"]
  end

  def text(%{text: text, marks: marks}) do
    escape_xml(text) |> wrap_marks(marks)
  end

  def escape_xml(text) do
    String.replace(text, "&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("'", "&apos;")
    |> String.replace("\"", "&quot;")
  end

  def document(next, %{data: %{id: id, title: title}}) do
    [
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
      "<!DOCTYPE workbook_page PUBLIC \"-//Carnegie Mellon University//DTD Workbook Page MathML 3.8//EN\" \"http://oli.web.cmu.edu/dtd/oli_workbook_page_mathml_3_8.dtd\">\n",
      "<workbook_page id=\"#{id}\"><head><title>#{title}</title></head><body>\n",
      next.(),
      "</body></workbook_page>"
    ]
  end

  @spec organization((() -> any), %{id: any, title: any}) :: [...]
  def organization(next, %{id: id, title: title}) do
    [
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
      "<!DOCTYPE organization PUBLIC \"-//Carnegie Mellon University//DTD Content Organization Simple 2.3//EN\" \"http://oli.web.cmu.edu/dtd/oli_content_organization_simple_2_3.dtd\">\n",
      "<organization id=\"#{id}\" version=\"1.0\">\n",
      "<title>#{title}</title>\n",
      "<description>organization description</description>\n",
      "<audience>Audience</audience>\n",
      "<labels sequence=\"Sequence\" unit=\"Unit\" module=\"Module\" section=\"Section\"/>\n",
      "<sequences>\n",
      "<sequence id=\"main_sequence\" category=\"content\" audience=\"all\">\n",
      "<title>Main Sequence</title>\n",
      next.(),
      "</sequence>\n",
      "</sequences></organization>\n"
    ]
  end

  def module(next, %{id: id, title: title}) do
    [
      "<module id=\"#{id}\">\n",
      "<title>#{title}</title>\n",
      next.(),
      "</module>\n"
    ]
  end

  def reference(_, %{id: id}) do
    [
      "<item id=\"ref_#{id}\" scoring_mode=\"default\">\n",
      "<resourceref idref=\"#{id}\"/>\n",
      "</item>\n"
    ]
  end

  def wrap_marks(text, marks) do
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
      fn %{type: m}, t ->
        "<" <> Map.get(map, m) <> ">" <> t <> "</" <> Map.get(map, m) <> ">"
      end
    )
  end
end
