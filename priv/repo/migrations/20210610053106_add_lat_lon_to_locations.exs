defmodule Manatee.Repo.Migrations.AddLatLonToLocations do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :lat, :float
      add :lon, :float
    end
  end
end
