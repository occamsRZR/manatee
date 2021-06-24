defmodule Manatee.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :ingredients, :string
    field :interval, :string
    field :interval_unit, Ecto.Enum, values: [:day, :gdd]
    field :name, :string
    field :rate, :float

    field :n_analysis, :float
    field :p_analysis, :float
    field :k_analysis, :float
    field :ca_analysis, :float
    field :mg_analysis, :float
    field :s_analysis, :float
    field :fe_analysis, :float
    field :mn_analysis, :float

    field :rate_unit, Ecto.Enum,
      values: [
        :g_per_m,
        :oz_per_m,
        :ml_per_m,
        :lb_per_m
      ]

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :ingredients,
      :rate,
      :rate_unit,
      :n_analysis,
      :p_analysis,
      :k_analysis,
      :ca_analysis,
      :mg_analysis,
      :s_analysis,
      :fe_analysis,
      :mn_analysis,
      :interval,
      :interval_unit
    ])
    |> validate_required([:name, :ingredients, :rate, :rate_unit, :interval, :interval_unit])
  end
end
