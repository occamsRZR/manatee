defmodule Manatee.Applications.ApplicationProduct do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "application_products" do
    field :interval, :integer
    field :interval_unit, Ecto.Enum, values: [:day, :gdd, :none]

    field :rate, :float

    field :rate_unit, Ecto.Enum,
      values: [
        :g_per_m,
        :oz_per_m,
        :ml_per_m,
        :lbs_per_m,
        :floz_per_m
      ]

    field :n_lbs_per_m, :float
    field :p_lbs_per_m, :float
    field :k_lbs_per_m, :float
    field :ca_lbs_per_m, :float
    field :mg_lbs_per_m, :float
    field :s_lbs_per_m, :float
    field :fe_lbs_per_m, :float
    field :mn_lbs_per_m, :float

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true
    belongs_to :application, Manatee.Applications.Application
    belongs_to :product, Manatee.Products.Product

    timestamps()
  end

  @doc false
  def changeset(application_product, attrs) do
    application_product
    # So its persisted
    |> Map.put(:temp_id, application_product.temp_id || attrs["temp_id"])
    |> cast(attrs, [
      :delete,
      :product_id,
      :rate,
      :rate_unit,
      :interval,
      :interval_unit,
      # :area,
      :application_id,
      :n_lbs_per_m,
      :p_lbs_per_m,
      :k_lbs_per_m,
      :ca_lbs_per_m,
      :mg_lbs_per_m,
      :s_lbs_per_m,
      :fe_lbs_per_m,
      :mn_lbs_per_m
    ])
    |> cast_assoc(:product)
    |> validate_required([:rate, :rate_unit, :interval, :interval_unit, :product_id])
    |> pounds_per_m(attrs)
  end

  defp pounds_per_m(
         %Ecto.Changeset{errors: errors, changes: %{rate: rate_casted}} = changeset,
         %{"product_id" => product_id, "rate" => rate} = attrs
       ) do
    with product <- Manatee.Products.get_product!(product_id) do
      IO.inspect(changeset)

      changeset =
        change(changeset, %{
          n_lbs_per_m: calculate_lbs_per_m(rate_casted, product.n_analysis),
          p_lbs_per_m: calculate_lbs_per_m(rate_casted, product.p_analysis),
          k_lbs_per_m: calculate_lbs_per_m(rate_casted, product.k_analysis)
        })

      changeset
    end
  end

  defp pounds_per_m(changeset, _), do: changeset

  defp calculate_lbs_per_m(_, analysis) when is_nil(analysis), do: 0.0

  defp calculate_lbs_per_m(rate, analysis) when is_float(rate) do
    # take rate, by percentage analysis, by 1/100th for total lbs/M
    rate * analysis * 0.01
  end

  defp calculate_lbs_per_m(_, analysis), do: analysis * 1.0
end
