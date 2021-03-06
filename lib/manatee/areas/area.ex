defmodule Manatee.Areas.Area do
  use Ecto.Schema
  import Ecto.Changeset

  alias Manatee.Applications.Application
  alias Manatee.Locations.Location

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "areas" do
    field :area, :integer
    field :area_unit, :string
    field :name, :string

    field :grass_type, Ecto.Enum,
      values: [
        :cool_season,
        :warm_season
      ]

    belongs_to(:location, Location)
    has_many(:applications, Application)

    timestamps()
  end

  @doc false
  def changeset(area, attrs) do
    area
    |> cast(attrs, [:name, :area, :area_unit, :location_id, :grass_type])
    |> validate_required([:name, :area, :area_unit, :location_id, :grass_type])
  end
end
