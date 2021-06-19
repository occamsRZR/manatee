defmodule Manatee.Applications.ApplicationProduct do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "application_products" do
    field :interval, :integer
    field :interval_unit, Ecto.Enum, values: [:gdd, :days]
    field :rate, :float
    field :rate_unit, Ecto.Enum, values: [:oz_per_m, :g_per_m, :lbs_per_m, :kg_per_m]
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
      :rate,
      :rate_unit,
      :interval,
      :interval_unit,
      # :area,
      :application_id,
      :product_id
    ])
    |> validate_required([:rate, :rate_unit, :interval, :interval_unit])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
