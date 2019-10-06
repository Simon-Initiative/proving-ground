defmodule Delivery.PagesTest do
  use Delivery.DataCase

  alias Delivery.Pages

  describe "pages" do
    alias Delivery.Pages.Page

    @valid_attrs %{friendly: "some friendly"}
    @update_attrs %{friendly: "some updated friendly"}
    @invalid_attrs %{friendly: nil}

    def page_fixture(attrs \\ %{}) do
      {:ok, page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pages.create_page()

      page
    end

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Pages.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Pages.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = Pages.create_page(@valid_attrs)
      assert page.friendly == "some friendly"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, %Page{} = page} = Pages.update_page(page, @update_attrs)
      assert page.friendly == "some updated friendly"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_page(page, @invalid_attrs)
      assert page == Pages.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Pages.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Pages.change_page(page)
    end
  end

  describe "revision" do
    alias Delivery.Pages.Revision

    @valid_attrs %{content: %{}, graded: true, page_id: 42, requires_completion: true, revision_type: "some revision_type", timed: true, title: "some title", type: "some type"}
    @update_attrs %{content: %{}, graded: false, page_id: 43, requires_completion: false, revision_type: "some updated revision_type", timed: false, title: "some updated title", type: "some updated type"}
    @invalid_attrs %{content: nil, graded: nil, page_id: nil, requires_completion: nil, revision_type: nil, timed: nil, title: nil, type: nil}

    def revision_fixture(attrs \\ %{}) do
      {:ok, revision} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pages.create_revision()

      revision
    end

    test "list_revision/0 returns all revision" do
      revision = revision_fixture()
      assert Pages.list_revision() == [revision]
    end

    test "get_revision!/1 returns the revision with given id" do
      revision = revision_fixture()
      assert Pages.get_revision!(revision.id) == revision
    end

    test "create_revision/1 with valid data creates a revision" do
      assert {:ok, %Revision{} = revision} = Pages.create_revision(@valid_attrs)
      assert revision.content == %{}
      assert revision.graded == true
      assert revision.page_id == 42
      assert revision.requires_completion == true
      assert revision.revision_type == "some revision_type"
      assert revision.timed == true
      assert revision.title == "some title"
      assert revision.type == "some type"
    end

    test "create_revision/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_revision(@invalid_attrs)
    end

    test "update_revision/2 with valid data updates the revision" do
      revision = revision_fixture()
      assert {:ok, %Revision{} = revision} = Pages.update_revision(revision, @update_attrs)
      assert revision.content == %{}
      assert revision.graded == false
      assert revision.page_id == 43
      assert revision.requires_completion == false
      assert revision.revision_type == "some updated revision_type"
      assert revision.timed == false
      assert revision.title == "some updated title"
      assert revision.type == "some updated type"
    end

    test "update_revision/2 with invalid data returns error changeset" do
      revision = revision_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_revision(revision, @invalid_attrs)
      assert revision == Pages.get_revision!(revision.id)
    end

    test "delete_revision/1 deletes the revision" do
      revision = revision_fixture()
      assert {:ok, %Revision{}} = Pages.delete_revision(revision)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_revision!(revision.id) end
    end

    test "change_revision/1 returns a revision changeset" do
      revision = revision_fixture()
      assert %Ecto.Changeset{} = Pages.change_revision(revision)
    end
  end
end
