defmodule Delivery.Packages.Package do
  use Ecto.Schema
  import Ecto.Changeset

  schema "packages" do
    field :description, :string
    field :friendly, :string
    field :title, :string
    field :version, :string

    timestamps()
  end

  @doc false
  def changeset(package, attrs) do

    changeset = package
    |> cast(attrs, [:friendly, :title, :version, :description])
    |> validate_required([:title, :version, :description])
    |> validate_format(:version, ~r/^[0-9]\.[0-9]\.[0-9]$/,
      message: "must follow a X.Y.Z format")

    case package.id do
      nil -> generate_friendly(changeset)
      _ -> changeset
    end
  end

  defp generate_friendly(changeset) do
    set_unique_friendly(
      changeset,
      get_change(changeset, :title) |> to_friendly,
      [""] ++ ~w(_1 _2 _3 _4 _5) ++ [str(6), str(6), str(6)])
  end

  @chars "abcdefghijklmnopqrstuvwxyz" |> String.split("")

  def str(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end

  defp set_unique_friendly(changeset, "", _suffixes) do
    changeset
  end

  defp set_unique_friendly(changeset, title, [suffix | remaining]) do

    candidate = title <> suffix

    query = Ecto.Adapters.SQL.query(
      Delivery.Repo, "SELECT * FROM packages WHERE friendly = $1;", [candidate])

    case query do
      {:ok, %{num_rows: 0 }} -> changeset |> put_change(:friendly, candidate)
      {:ok, _results } -> set_unique_friendly(changeset, title, remaining)
    end

  end

  defp set_unique_friendly(changeset, _, []) do
    changeset |> add_error(:friendly, "must be unique")
  end


  defp to_friendly(nil) do
    ""
  end

  defp to_friendly(title) do
    String.downcase(title, :default) |> String.replace(" ", "_")
  end

  def validate_uniqueness(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, friendly ->

      {:ok, %{num_rows: num_rows }} = Ecto.Adapters.SQL.query(
      Delivery.Repo, "SELECT * FROM packages WHERE friendly = $1;", [friendly])

      case num_rows do
        0 -> []
        1 -> [{field, options[:message] || "This friendly id is already taken"}]
      end
    end)
  end
end
