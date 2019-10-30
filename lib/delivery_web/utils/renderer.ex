defmodule DeliveryWeb.Utils.Renderer do
  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Inline
  alias Delivery.Content.Text

  @type next :: (() -> String.t())
  @type nodes :: [%{}]
  @type data :: %{}
  @type marks :: []

  @callback document(next, %Document{}) :: [any()]

  @callback p(next, %Block{}) :: [any()]
  @callback table(next, %Block{}) :: [any()]
  @callback tbody(next, %Block{}) :: [any()]
  @callback thead(next, %Block{}) :: [any()]
  @callback tr(next, %Block{}) :: [any()]
  @callback td(next, %Block{}) :: [any()]
  @callback th(next, %Block{}) :: [any()]
  @callback image(next, %Block{}) :: [any()]
  @callback youtube(next, %Block{}) :: [any()]
  @callback ul(next, %Block{}) :: [any()]
  @callback ol(next, %Block{}) :: [any()]
  @callback li(next, %Block{}) :: [any()]
  @callback h1(next, %Block{}) :: [any()]
  @callback h2(next, %Block{}) :: [any()]
  @callback h3(next, %Block{}) :: [any()]
  @callback h4(next, %Block{}) :: [any()]
  @callback h5(next, %Block{}) :: [any()]
  @callback h6(next, %Block{}) :: [any()]
  @callback blockquote(next, %Block{}) :: [any()]
  @callback audio(next, %Block{}) :: [any()]
  @callback a(next, %Inline{}) :: [any()]
  @callback definition(next, %Inline{}) :: [any()]
  @callback text(%Text{}) :: [any()]

  def render(impl, %Document{nodes: nodes} = doc) do
    next = fn -> render(impl, nodes) end
    impl.document(next, doc)
  end

  def render(impl, %Block{type: type, nodes: nodes} = block) do
    next = fn -> render(impl, nodes) end

    case type do
      "paragraph" -> impl.p(next, block)
      "table" -> impl.table(next, block)
      "thead" -> impl.thead(next, block)
      "tbody" -> impl.tbody(next, block)
      "tr" -> impl.tr(next, block)
      "td" -> impl.td(next, block)
      "th" -> impl.th(next, block)
      "image" -> impl.image(next, block)
      "youtube" -> impl.youtube(next, block)
      "unordered-list" -> impl.ul(next, block)
      "ordered-list" -> impl.ol(next, block)
      "list-item" -> impl.li(next, block)
      "heading-one" -> impl.h1(next, block)
      "heading-two" -> impl.h2(next, block)
      "heading-three" -> impl.h3(next, block)
      "heading-four" -> impl.h4(next, block)
      "heading-five" -> impl.h5(next, block)
      "heading-six" -> impl.h6(next, block)
      "blockquote" -> impl.blockquote(next, block)
      "audio" -> impl.audio(next, block)
    end
  end

  def render(impl, %Inline{type: type, nodes: nodes} = inline) do
    next = fn -> render(impl, nodes) end

    case type do
      "a" -> impl.a(next, inline)
      "definition" -> impl.definition(next, inline)
    end
  end

  def render(impl, %Text{} = text) do
    impl.text(text)
  end

  def render(impl, nodes) when is_list(nodes) do
    Enum.map(nodes, fn n -> render(impl, n) end)
  end
end
