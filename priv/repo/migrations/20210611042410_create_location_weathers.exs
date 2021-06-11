defmodule Manatee.Repo.Migrations.CreateLocationWeathers do
  use Ecto.Migration

  def change do
    create table(:location_weathers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :min_temp, :float
      add :max_temp, :float
      add :humidity, :float
      add :day, :date
      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:location_weathers, [:location_id])
  end
end
