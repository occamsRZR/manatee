defmodule Manatee.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

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

      case Geocoder.call(
             location_info.address <>
               " " <>
               location_info.city <>
               ", " <>
               location_info.state <>
               " " <>
               location_info.zip
           ) do
        {:ok, coordinates} ->
          change(changeset, %{lat: coordinates.lat, lon: coordinates.lon})

        {:error, _} ->
          changeset
      end
    else
      changeset
    end
  end
end
