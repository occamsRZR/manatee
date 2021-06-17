defmodule ManateeWeb.LocationWeatherController do
  use ManateeWeb, :controller

  alias Manatee.Locations
  alias Manatee.Locations.LocationWeather

  action_fallback ManateeWeb.FallbackController

  def index(conn, _params) do
    location_weathers = Locations.list_location_weathers()
    render(conn, "index.json", location_weathers: location_weathers)
  end

  def create(conn, %{"location_weather" => location_weather_params}) do
    with {:ok, %LocationWeather{} = location_weather} <- Locations.create_location_weather(location_weather_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.location_weather_path(conn, :show, location_weather))
      |> render("show.json", location_weather: location_weather)
    end
  end

  def show(conn, %{"id" => id}) do
    location_weather = Locations.get_location_weather!(id)
    render(conn, "show.json", location_weather: location_weather)
  end

  def update(conn, %{"id" => id, "location_weather" => location_weather_params}) do
    location_weather = Locations.get_location_weather!(id)

    with {:ok, %LocationWeather{} = location_weather} <- Locations.update_location_weather(location_weather, location_weather_params) do
      render(conn, "show.json", location_weather: location_weather)
    end
  end

  def delete(conn, %{"id" => id}) do
    location_weather = Locations.get_location_weather!(id)

    with {:ok, %LocationWeather{}} <- Locations.delete_location_weather(location_weather) do
      send_resp(conn, :no_content, "")
    end
  end
end
