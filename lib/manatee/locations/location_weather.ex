defmodule Manatee.Locations.LocationWeather do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "location_weathers" do
    field :day, :date
    field :humidity, :float
    field :max_temp, :float
    field :min_temp, :float
    field :location_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(location_weather, attrs) do
    location_weather
    |> cast(attrs, [:min_temp, :max_temp, :humidity, :day, :location_id])
    |> validate_required([:min_temp, :max_temp, :humidity, :day])
  end
end
