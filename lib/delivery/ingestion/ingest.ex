defmodule Delivery.Ingestion.Ingest do

  alias Delivery.Content.Document

  @callback segment(String.t) :: {:ok, [String.t]} | {:error, String.t}
  @callback parse(String.t) :: {:ok, %Document{}} | {:error, String.t}
  @callback determine_type(String.t) :: String.t
end
