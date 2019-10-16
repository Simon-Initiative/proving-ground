defmodule Delivery.LibraryTest do
  use Delivery.DataCase

  alias Delivery.Library

  describe "snippets" do
    alias Delivery.Library.Snippet

    @valid_attrs %{content: %{}, name: "some name"}
    @update_attrs %{content: %{}, name: "some updated name"}
    @invalid_attrs %{content: nil, name: nil}

    def snippet_fixture(attrs \\ %{}) do
      {:ok, snippet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Library.create_snippet()

      snippet
    end

    test "list_snippets/0 returns all snippets" do
      snippet = snippet_fixture()
      assert Library.list_snippets() == [snippet]
    end

    test "get_snippet!/1 returns the snippet with given id" do
      snippet = snippet_fixture()
      assert Library.get_snippet!(snippet.id) == snippet
    end

    test "create_snippet/1 with valid data creates a snippet" do
      assert {:ok, %Snippet{} = snippet} = Library.create_snippet(@valid_attrs)
      assert snippet.content == %{}
      assert snippet.name == "some name"
    end

    test "create_snippet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_snippet(@invalid_attrs)
    end

    test "update_snippet/2 with valid data updates the snippet" do
      snippet = snippet_fixture()
      assert {:ok, %Snippet{} = snippet} = Library.update_snippet(snippet, @update_attrs)
      assert snippet.content == %{}
      assert snippet.name == "some updated name"
    end

    test "update_snippet/2 with invalid data returns error changeset" do
      snippet = snippet_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_snippet(snippet, @invalid_attrs)
      assert snippet == Library.get_snippet!(snippet.id)
    end

    test "delete_snippet/1 deletes the snippet" do
      snippet = snippet_fixture()
      assert {:ok, %Snippet{}} = Library.delete_snippet(snippet)
      assert_raise Ecto.NoResultsError, fn -> Library.get_snippet!(snippet.id) end
    end

    test "change_snippet/1 returns a snippet changeset" do
      snippet = snippet_fixture()
      assert %Ecto.Changeset{} = Library.change_snippet(snippet)
    end
  end
end
