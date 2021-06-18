defmodule Manatee.Areass.Area do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "areas" do
    field :area, :integer
    field :area_unit, :string
    field :name, :string
    field :location_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(area, attrs) do
    area
    |> cast(attrs, [:name, :area, :area_unit])
    |> validate_required([:name, :area, :area_unit])
  end
end
