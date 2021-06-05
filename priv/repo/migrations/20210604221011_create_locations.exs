defmodule Manatee.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :string

      timestamps()
    end

  end
end
