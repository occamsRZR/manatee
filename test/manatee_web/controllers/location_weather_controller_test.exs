defmodule ManateeWeb.LocationWeatherControllerTest do
  use ManateeWeb.ConnCase

  alias Manatee.Locations
  alias Manatee.Locations.LocationWeather

  @create_attrs %{
    day: ~D[2010-04-17],
    humidity: 120.5,
    max_temp: 120.5,
    min_temp: 120.5
  }
  @update_attrs %{
    day: ~D[2011-05-18],
    humidity: 456.7,
    max_temp: 456.7,
    min_temp: 456.7
  }
  @invalid_attrs %{day: nil, humidity: nil, max_temp: nil, min_temp: nil}

  def fixture(:location_weather) do
    {:ok, location_weather} = Locations.create_location_weather(@create_attrs)
    location_weather
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all location_weathers", %{conn: conn} do
      conn = get(conn, Routes.location_weather_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create location_weather" do
    test "renders location_weather when data is valid", %{conn: conn} do
      conn = post(conn, Routes.location_weather_path(conn, :create), location_weather: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.location_weather_path(conn, :show, id))

      assert %{
               "id" => id,
               "day" => "2010-04-17",
               "humidity" => 120.5,
               "max_temp" => 120.5,
               "min_temp" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.location_weather_path(conn, :create), location_weather: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update location_weather" do
    setup [:create_location_weather]

    test "renders location_weather when data is valid", %{conn: conn, location_weather: %LocationWeather{id: id} = location_weather} do
      conn = put(conn, Routes.location_weather_path(conn, :update, location_weather), location_weather: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.location_weather_path(conn, :show, id))

      assert %{
               "id" => id,
               "day" => "2011-05-18",
               "humidity" => 456.7,
               "max_temp" => 456.7,
               "min_temp" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, location_weather: location_weather} do
      conn = put(conn, Routes.location_weather_path(conn, :update, location_weather), location_weather: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete location_weather" do
    setup [:create_location_weather]

    test "deletes chosen location_weather", %{conn: conn, location_weather: location_weather} do
      conn = delete(conn, Routes.location_weather_path(conn, :delete, location_weather))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.location_weather_path(conn, :show, location_weather))
      end
    end
  end

  defp create_location_weather(_) do
    location_weather = fixture(:location_weather)
    %{location_weather: location_weather}
  end
end
