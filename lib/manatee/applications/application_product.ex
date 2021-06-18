defmodule Manatee.Applications.ApplicationProduct do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "application_products" do
    field :interval, :integer
    field :interval_unit, :string
    field :rate, :float
    field :rate_unit, :string
    field :application_id, :binary_id
    field :area_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(application_product, attrs) do
    application_product
    |> cast(attrs, [:rate, :rate_unit, :interval, :interval_unit])
    |> validate_required([:rate, :rate_unit, :interval, :interval_unit])
  end
end
