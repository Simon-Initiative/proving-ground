defmodule Delivery.Content.Schema.V1 do

  use Delivery.Content.Schema.Generator

  block "paragraph" do
    field :id, :string, :required
    contains [:text]
  end

  block "image" do
    field :id, :string, :required
    field :src, :string, :required
    field :height, :integer, 300
    field :width, :integer, 300
  end

  block "ul" do
    field :id, :string, :required
    contains ["li"]
  end

  block "li" do
    field :id, :string, :required
    contains ["paragraph"]
  end

end
