defmodule Manatee.LocationsTest do
  use Manatee.DataCase

  alias Manatee.Locations

  describe "locations" do
    alias Manatee.Locations.Location

    @valid_attrs %{address: "some address", city: "some city", name: "some name", state: "some state", zip: "some zip"}
    @update_attrs %{address: "some updated address", city: "some updated city", name: "some updated name", state: "some updated state", zip: "some updated zip"}
    @invalid_attrs %{address: nil, city: nil, name: nil, state: nil, zip: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Locations.create_location()

      location
    end

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Locations.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Locations.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      assert {:ok, %Location{} = location} = Locations.create_location(@valid_attrs)
      assert location.address == "some address"
      assert location.city == "some city"
      assert location.name == "some name"
      assert location.state == "some state"
      assert location.zip == "some zip"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locations.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, %Location{} = location} = Locations.update_location(location, @update_attrs)
      assert location.address == "some updated address"
      assert location.city == "some updated city"
      assert location.name == "some updated name"
      assert location.state == "some updated state"
      assert location.zip == "some updated zip"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Locations.update_location(location, @invalid_attrs)
      assert location == Locations.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Locations.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Locations.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Locations.change_location(location)
    end
  end

  describe "location_weathers" do
    alias Manatee.Locations.LocationWeather

    @valid_attrs %{day: ~D[2010-04-17], humidity: 120.5, max_temp: 120.5, min_temp: 120.5}
    @update_attrs %{day: ~D[2011-05-18], humidity: 456.7, max_temp: 456.7, min_temp: 456.7}
    @invalid_attrs %{day: nil, humidity: nil, max_temp: nil, min_temp: nil}

    def location_weather_fixture(attrs \\ %{}) do
      {:ok, location_weather} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Locations.create_location_weather()

      location_weather
    end

    test "list_location_weathers/0 returns all location_weathers" do
      location_weather = location_weather_fixture()
      assert Locations.list_location_weathers() == [location_weather]
    end

    test "get_location_weather!/1 returns the location_weather with given id" do
      location_weather = location_weather_fixture()
      assert Locations.get_location_weather!(location_weather.id) == location_weather
    end

    test "create_location_weather/1 with valid data creates a location_weather" do
      assert {:ok, %LocationWeather{} = location_weather} = Locations.create_location_weather(@valid_attrs)
      assert location_weather.day == ~D[2010-04-17]
      assert location_weather.humidity == 120.5
      assert location_weather.max_temp == 120.5
      assert location_weather.min_temp == 120.5
    end

    test "create_location_weather/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locations.create_location_weather(@invalid_attrs)
    end

    test "update_location_weather/2 with valid data updates the location_weather" do
      location_weather = location_weather_fixture()
      assert {:ok, %LocationWeather{} = location_weather} = Locations.update_location_weather(location_weather, @update_attrs)
      assert location_weather.day == ~D[2011-05-18]
      assert location_weather.humidity == 456.7
      assert location_weather.max_temp == 456.7
      assert location_weather.min_temp == 456.7
    end

    test "update_location_weather/2 with invalid data returns error changeset" do
      location_weather = location_weather_fixture()
      assert {:error, %Ecto.Changeset{}} = Locations.update_location_weather(location_weather, @invalid_attrs)
      assert location_weather == Locations.get_location_weather!(location_weather.id)
    end

    test "delete_location_weather/1 deletes the location_weather" do
      location_weather = location_weather_fixture()
      assert {:ok, %LocationWeather{}} = Locations.delete_location_weather(location_weather)
      assert_raise Ecto.NoResultsError, fn -> Locations.get_location_weather!(location_weather.id) end
    end

    test "change_location_weather/1 returns a location_weather changeset" do
      location_weather = location_weather_fixture()
      assert %Ecto.Changeset{} = Locations.change_location_weather(location_weather)
    end
  end
end
