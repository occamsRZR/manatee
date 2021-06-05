defmodule Manatee.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :ingredients, :text
      add :rate, :float
      add :rate_unit, :string
      add :interval, :string
      add :interval_unit, :string

      timestamps()
    end

  end
end
