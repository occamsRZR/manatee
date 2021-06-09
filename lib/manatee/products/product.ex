defmodule Manatee.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :ingredients, :string
    field :interval, :string
    field :interval_unit, :string
    field :name, :string
    field :rate, :float
    field :rate_unit, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :ingredients, :rate, :rate_unit, :interval, :interval_unit])
    |> validate_required([:name, :ingredients, :rate, :rate_unit, :interval, :interval_unit])
  end
end
