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
    has_many :weathers, LocationWeather, on_delete: :delete_all
    belongs_to :user, Manatee.Accounts.User, type: :integer

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :address, :city, :state, :zip, :lat, :lon, :user_id])
    |> validate_required([:name, :address, :city, :state, :zip, :user_id])
    |> geocode(location)
  end

  defp geocode(%Ecto.Changeset{errors: errors} = changeset, location) do
    unless Enum.any?(errors) do
      location_info = Map.merge(location, changeset.changes)

      case Geocoder.call(
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
