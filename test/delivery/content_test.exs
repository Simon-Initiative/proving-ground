defmodule Delivery.ContentTest do
  use Delivery.DataCase

  alias Delivery.Content

  describe "activities" do
    alias Delivery.Content.Activity

    @valid_attrs %{content: %{}, title: "some title"}
    @update_attrs %{content: %{}, title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def activity_fixture(attrs \\ %{}) do
      {:ok, activity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_activity()

      activity
    end

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Content.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Content.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      assert {:ok, %Activity{} = activity} = Content.create_activity(@valid_attrs)
      assert activity.content == %{}
      assert activity.title == "some title"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{} = activity} = Content.update_activity(activity, @update_attrs)
      assert activity.content == %{}
      assert activity.title == "some updated title"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_activity(activity, @invalid_attrs)
      assert activity == Content.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Content.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Content.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Content.change_activity(activity)
    end
  end

  describe "snippets" do
    alias Delivery.Content.Snippet

    @valid_attrs %{content: %{}, title: "some title"}
    @update_attrs %{content: %{}, title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def snippet_fixture(attrs \\ %{}) do
      {:ok, snippet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_snippet()

      snippet
    end

    test "list_snippets/0 returns all snippets" do
      snippet = snippet_fixture()
      assert Content.list_snippets() == [snippet]
    end

    test "get_snippet!/1 returns the snippet with given id" do
      snippet = snippet_fixture()
      assert Content.get_snippet!(snippet.id) == snippet
    end

    test "create_snippet/1 with valid data creates a snippet" do
      assert {:ok, %Snippet{} = snippet} = Content.create_snippet(@valid_attrs)
      assert snippet.content == %{}
      assert snippet.title == "some title"
    end

    test "create_snippet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_snippet(@invalid_attrs)
    end

    test "update_snippet/2 with valid data updates the snippet" do
      snippet = snippet_fixture()
      assert {:ok, %Snippet{} = snippet} = Content.update_snippet(snippet, @update_attrs)
      assert snippet.content == %{}
      assert snippet.title == "some updated title"
    end

    test "update_snippet/2 with invalid data returns error changeset" do
      snippet = snippet_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_snippet(snippet, @invalid_attrs)
      assert snippet == Content.get_snippet!(snippet.id)
    end

    test "delete_snippet/1 deletes the snippet" do
      snippet = snippet_fixture()
      assert {:ok, %Snippet{}} = Content.delete_snippet(snippet)
      assert_raise Ecto.NoResultsError, fn -> Content.get_snippet!(snippet.id) end
    end

    test "change_snippet/1 returns a snippet changeset" do
      snippet = snippet_fixture()
      assert %Ecto.Changeset{} = Content.change_snippet(snippet)
    end
  end
end
