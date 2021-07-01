defmodule Manatee.Repo.Migrations.AddGrassTypeToAreas do
  use Ecto.Migration

  def change do
    alter table(:areas) do
      add :grass_type, :string, default: "cool_season"
    end
  end
end
