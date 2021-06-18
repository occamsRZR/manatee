defmodule Manatee.Repo.Migrations.CreateApplicationProducts do
  use Ecto.Migration

  def change do
    create table(:application_products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :rate, :float
      add :rate_unit, :string
      add :interval, :integer
      add :interval_unit, :string
      add :application_id, references(:applications, on_delete: :nothing, type: :binary_id)
      add :area_id, references(:areas, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:application_products, [:application_id])
    create index(:application_products, [:area_id])
  end
end
