defmodule ManateeWeb.LocationWeatherView do
  use ManateeWeb, :view
  alias ManateeWeb.LocationWeatherView

  def render("index.json", %{location_weathers: location_weathers}) do
    %{data: render_many(location_weathers, LocationWeatherView, "location_weather.json")}
  end

  def render("show.json", %{location_weather: location_weather}) do
    %{data: render_one(location_weather, LocationWeatherView, "location_weather.json")}
  end

  def render("location_weather.json", %{location_weather: location_weather}) do
    %{id: location_weather.id,
      min_temp: location_weather.min_temp,
      max_temp: location_weather.max_temp,
      humidity: location_weather.humidity,
      day: location_weather.day}
  end
end
