defmodule Manatee.Repo.Migrations.CreateAreas do
  use Ecto.Migration

  def change do
    create table(:areas, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :area, :integer
      add :area_unit, :string
      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:areas, [:location_id])
  end
end
