defmodule Delivery.Content.Schema.V1 do
  use Delivery.Content.Schema.Generator

  @top_level ~w(paragaph, image, ul)

  block "paragraph" do
    field :id, :string, :required
    children([:text])
  end

  block "image" do
    field :id, :string, :required
    field :src, :string, :required
    field :height, :integer, 300
    field :width, :integer, 300
  end

  block "ul" do
    field :id, :string, :required
    children(["li"])
  end

  block "li" do
    field :id, :string, :required
    children(["paragraph"])
  end
end
