defmodule Manatee.Locations.Location do
  alias Manatee.Locations.LocationWeather
  use Ecto.Schema
  import Ecto.Changeset
  alias Manatee.Locations.LocationWeather

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "locations" do
    field :address, :string
    field :city, :string
    field :name, :string
    field :state, :string
    field :zip, :string
    field :lat, :float
    field :lon, :float
    has_many :weathers, LocationWeather

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :address, :city, :state, :zip, :lat, :lon])
    |> validate_required([:name, :address, :city, :state, :zip])
    |> geocode(location)
  end

  defp geocode(%Ecto.Changeset{errors: errors} = changeset, location) do
    unless Enum.any?(errors) do
      location_info = Map.merge(location, changeset.changes)

      {:ok, coordinates} =
        Geocoder.call(
          location_info.address <>
            " " <>
            location_info.city <>
            ", " <>
            location_info.state <>
            " " <>
            location_info.zip
        )

      lat = coordinates.lat
      lon = coordinates.lon

      change(changeset, %{lat: lat, lon: lon})
    else
      changeset
    end
  end
end
