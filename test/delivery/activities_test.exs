defmodule Delivery.ActivitiesTest do
  use Delivery.DataCase

  alias Delivery.Activities

  describe "activities" do
    alias Delivery.Activities.Activity

    @valid_attrs %{friendly: "some friendly"}
    @update_attrs %{friendly: "some updated friendly"}
    @invalid_attrs %{friendly: nil}

    def activity_fixture(attrs \\ %{}) do
      {:ok, activity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity()

      activity
    end

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      assert {:ok, %Activity{} = activity} = Activities.create_activity(@valid_attrs)
      assert activity.friendly == "some friendly"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, @update_attrs)
      assert activity.friendly == "some updated friendly"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end

  describe "revision" do
    alias Delivery.Activities.ActivityRevision

    @valid_attrs %{activity_id: 42, content: %{}, purpose: "some purpose", revision_type: "some revision_type", title: "some title", type: "some type"}
    @update_attrs %{activity_id: 43, content: %{}, purpose: "some updated purpose", revision_type: "some updated revision_type", title: "some updated title", type: "some updated type"}
    @invalid_attrs %{activity_id: nil, content: nil, purpose: nil, revision_type: nil, title: nil, type: nil}

    def activity_revision_fixture(attrs \\ %{}) do
      {:ok, activity_revision} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity_revision()

      activity_revision
    end

    test "list_revision/0 returns all revision" do
      activity_revision = activity_revision_fixture()
      assert Activities.list_revision() == [activity_revision]
    end

    test "get_activity_revision!/1 returns the activity_revision with given id" do
      activity_revision = activity_revision_fixture()
      assert Activities.get_activity_revision!(activity_revision.id) == activity_revision
    end

    test "create_activity_revision/1 with valid data creates a activity_revision" do
      assert {:ok, %ActivityRevision{} = activity_revision} = Activities.create_activity_revision(@valid_attrs)
      assert activity_revision.activity_id == 42
      assert activity_revision.content == %{}
      assert activity_revision.purpose == "some purpose"
      assert activity_revision.revision_type == "some revision_type"
      assert activity_revision.title == "some title"
      assert activity_revision.type == "some type"
    end

    test "create_activity_revision/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_revision(@invalid_attrs)
    end

    test "update_activity_revision/2 with valid data updates the activity_revision" do
      activity_revision = activity_revision_fixture()
      assert {:ok, %ActivityRevision{} = activity_revision} = Activities.update_activity_revision(activity_revision, @update_attrs)
      assert activity_revision.activity_id == 43
      assert activity_revision.content == %{}
      assert activity_revision.purpose == "some updated purpose"
      assert activity_revision.revision_type == "some updated revision_type"
      assert activity_revision.title == "some updated title"
      assert activity_revision.type == "some updated type"
    end

    test "update_activity_revision/2 with invalid data returns error changeset" do
      activity_revision = activity_revision_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity_revision(activity_revision, @invalid_attrs)
      assert activity_revision == Activities.get_activity_revision!(activity_revision.id)
    end

    test "delete_activity_revision/1 deletes the activity_revision" do
      activity_revision = activity_revision_fixture()
      assert {:ok, %ActivityRevision{}} = Activities.delete_activity_revision(activity_revision)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity_revision!(activity_revision.id) end
    end

    test "change_activity_revision/1 returns a activity_revision changeset" do
      activity_revision = activity_revision_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity_revision(activity_revision)
    end
  end

  describe "activities" do
    alias Delivery.Activities.Activity

    @valid_attrs %{content: %{}, draft_content: %{}, draft_title: "some draft_title", friendly: "some friendly", grading_strategy: "some grading_strategy", require_completion: true, tags: [], timed: true, title: "some title", type: "some type"}
    @update_attrs %{content: %{}, draft_content: %{}, draft_title: "some updated draft_title", friendly: "some updated friendly", grading_strategy: "some updated grading_strategy", require_completion: false, tags: [], timed: false, title: "some updated title", type: "some updated type"}
    @invalid_attrs %{content: nil, draft_content: nil, draft_title: nil, friendly: nil, grading_strategy: nil, require_completion: nil, tags: nil, timed: nil, title: nil, type: nil}

    def activity_fixture(attrs \\ %{}) do
      {:ok, activity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity()

      activity
    end

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      assert {:ok, %Activity{} = activity} = Activities.create_activity(@valid_attrs)
      assert activity.content == %{}
      assert activity.draft_content == %{}
      assert activity.draft_title == "some draft_title"
      assert activity.friendly == "some friendly"
      assert activity.grading_strategy == "some grading_strategy"
      assert activity.require_completion == true
      assert activity.tags == []
      assert activity.timed == true
      assert activity.title == "some title"
      assert activity.type == "some type"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, @update_attrs)
      assert activity.content == %{}
      assert activity.draft_content == %{}
      assert activity.draft_title == "some updated draft_title"
      assert activity.friendly == "some updated friendly"
      assert activity.grading_strategy == "some updated grading_strategy"
      assert activity.require_completion == false
      assert activity.tags == []
      assert activity.timed == false
      assert activity.title == "some updated title"
      assert activity.type == "some updated type"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end
end
