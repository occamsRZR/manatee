defmodule Manatee.AreasTest do
  use Manatee.DataCase

  alias Manatee.Areas

  describe "areas" do
    alias Manatee.Areas.Area

    @valid_attrs %{area: 42, area_unit: "some area_unit", name: "some name"}
    @update_attrs %{area: 43, area_unit: "some updated area_unit", name: "some updated name"}
    @invalid_attrs %{area: nil, area_unit: nil, name: nil}

    def area_fixture(attrs \\ %{}) do
      {:ok, area} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Areas.create_area()

      area
    end

    test "list_areas/0 returns all areas" do
      area = area_fixture()
      assert Areas.list_areas() == [area]
    end

    test "get_area!/1 returns the area with given id" do
      area = area_fixture()
      assert Areas.get_area!(area.id) == area
    end

    test "create_area/1 with valid data creates a area" do
      assert {:ok, %Area{} = area} = Areas.create_area(@valid_attrs)
      assert area.area == 42
      assert area.area_unit == "some area_unit"
      assert area.name == "some name"
    end

    test "create_area/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Areas.create_area(@invalid_attrs)
    end

    test "update_area/2 with valid data updates the area" do
      area = area_fixture()
      assert {:ok, %Area{} = area} = Areas.update_area(area, @update_attrs)
      assert area.area == 43
      assert area.area_unit == "some updated area_unit"
      assert area.name == "some updated name"
    end

    test "update_area/2 with invalid data returns error changeset" do
      area = area_fixture()
      assert {:error, %Ecto.Changeset{}} = Areas.update_area(area, @invalid_attrs)
      assert area == Areas.get_area!(area.id)
    end

    test "delete_area/1 deletes the area" do
      area = area_fixture()
      assert {:ok, %Area{}} = Areas.delete_area(area)
      assert_raise Ecto.NoResultsError, fn -> Areas.get_area!(area.id) end
    end

    test "change_area/1 returns a area changeset" do
      area = area_fixture()
      assert %Ecto.Changeset{} = Areas.change_area(area)
    end
  end
end
