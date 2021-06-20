defmodule Manatee.Applications.Application do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "applications" do
    field :applied_at, :utc_datetime
    field :description, :string
    belongs_to :area, Manatee.Areas.Area
    has_many :application_products, Manatee.Applications.ApplicationProduct

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:description, :applied_at])
    |> put_assoc(:application_products, attrs[:application_products])
    |> validate_required([:description, :applied_at])
  end
end
