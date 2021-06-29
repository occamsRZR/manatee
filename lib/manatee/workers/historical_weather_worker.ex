defmodule Manatee.Workers.HistoricalWeatherWorker do
  use Oban.Worker

  alias Manatee.Locations

  @impl Oban.Worker
  def perform(_job) do
    # Perform some work and then return :ok
    Locations.by_geocoded()
    |> Enum.map(fn loc ->
      Locations.backfill_location_weather(loc.id, 1)
    end)

    :ok
  end
end
