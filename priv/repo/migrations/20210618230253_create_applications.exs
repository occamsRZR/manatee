defmodule Manatee.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :applied_at, :utc_datetime
      add :area_id, references(:areas, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:applications, [:area_id])
  end
end
