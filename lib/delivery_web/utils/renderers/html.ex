defmodule DeliveryWeb.Utils.Renderers.HTML do
  alias DeliveryWeb.Utils.Types
  alias DeliveryWeb.Utils.Renderer
  alias DeliveryWeb.Utils.Link

  @behaviour Renderer

  @impl Renderer
  def paragraph(next, data) do
    case data.id do
      nil -> ""
      id -> "id=\"#{id}\""
    end

    """
    <p id="#{data.id}"}>#{next.()}</p>
    """
  end

  @impl Renderer
  def text(next, text, marks) do
    
    
  end
end
