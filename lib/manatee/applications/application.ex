defmodule Manatee.Applications.Application do
  use Ecto.Schema
  import Ecto.Changeset
  alias Manatee.Applications.ApplicationProduct

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "applications" do
    field :applied_at, :utc_datetime
    field :description, :string
    belongs_to :area, Manatee.Areas.Area

    has_many :application_products, ApplicationProduct, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    attrs = parse_applied_at(attrs)

    application
    |> cast(attrs, [:description, :applied_at, :area_id])
    |> validate_required([:description, :applied_at, :area_id])
  end

  defp parse_applied_at(attrs) do
    case Timex.parse(attrs["applied_at"], "%b %d, %Y %l:%M %p", :strftime) do
      {:ok, date} -> Map.put(attrs, "applied_at", date)
      {:error, _} -> attrs
    end
  end
end
