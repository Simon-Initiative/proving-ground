defmodule Delivery.Ingestion.Ingest do

  alias Delivery.Content.Document

  @callback segment(String.t) :: {:ok, %{}} | {:error, String.t}
  @callback page(any()) :: {:ok, %Document{}} | {:error, String.t}
  @callback organization(any()) :: {:ok, %Document{}} | {:error, String.t}
  @callback determine_type(String.t) :: String.t
end
