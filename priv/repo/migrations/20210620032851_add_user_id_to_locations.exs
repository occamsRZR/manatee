defmodule Manatee.Repo.Migrations.AddUserIdToLocations do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:locations, [:user_id])
  end
end
