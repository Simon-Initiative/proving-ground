defmodule Delivery.Content.Readers.Reader do
  alias Delivery.Content.Document
  alias Delivery.Content.Organization

  @callback segment(String.t()) :: {:ok, %{pages: [any()], toc: any()}} | {:error, String.t()}
  @callback page(any()) :: {:ok, %Document{}} | {:error, String.t()}
  @callback organization(any()) :: {:ok, %Organization{}} | {:error, String.t()}
  @callback determine_type(String.t()) :: String.t()
end
