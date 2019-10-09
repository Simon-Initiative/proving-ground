defmodule Delivery.SectionsTest do
  use Delivery.DataCase

  alias Delivery.Sections

  describe "sections" do
    alias Delivery.Sections.Section

    @valid_attrs %{end_date: ~D[2010-04-17], institution: "some institution", package_id: 42, start_date: ~D[2010-04-17], title: "some title"}
    @update_attrs %{end_date: ~D[2011-05-18], institution: "some updated institution", package_id: 43, start_date: ~D[2011-05-18], title: "some updated title"}
    @invalid_attrs %{end_date: nil, institution: nil, package_id: nil, start_date: nil, title: nil}

    def section_fixture(attrs \\ %{}) do
      {:ok, section} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sections.create_section()

      section
    end

    test "list_sections/0 returns all sections" do
      section = section_fixture()
      assert Sections.list_sections() == [section]
    end

    test "get_section!/1 returns the section with given id" do
      section = section_fixture()
      assert Sections.get_section!(section.id) == section
    end

    test "create_section/1 with valid data creates a section" do
      assert {:ok, %Section{} = section} = Sections.create_section(@valid_attrs)
      assert section.end_date == ~D[2010-04-17]
      assert section.institution == "some institution"
      assert section.package_id == 42
      assert section.start_date == ~D[2010-04-17]
      assert section.title == "some title"
    end

    test "create_section/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sections.create_section(@invalid_attrs)
    end

    test "update_section/2 with valid data updates the section" do
      section = section_fixture()
      assert {:ok, %Section{} = section} = Sections.update_section(section, @update_attrs)
      assert section.end_date == ~D[2011-05-18]
      assert section.institution == "some updated institution"
      assert section.package_id == 43
      assert section.start_date == ~D[2011-05-18]
      assert section.title == "some updated title"
    end

    test "update_section/2 with invalid data returns error changeset" do
      section = section_fixture()
      assert {:error, %Ecto.Changeset{}} = Sections.update_section(section, @invalid_attrs)
      assert section == Sections.get_section!(section.id)
    end

    test "delete_section/1 deletes the section" do
      section = section_fixture()
      assert {:ok, %Section{}} = Sections.delete_section(section)
      assert_raise Ecto.NoResultsError, fn -> Sections.get_section!(section.id) end
    end

    test "change_section/1 returns a section changeset" do
      section = section_fixture()
      assert %Ecto.Changeset{} = Sections.change_section(section)
    end
  end
end
