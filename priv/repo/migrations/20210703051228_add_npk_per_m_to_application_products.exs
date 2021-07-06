defmodule Manatee.Repo.Migrations.AddNpkPerMToApplicationProducts do
  use Ecto.Migration

  def change do
    alter table(:application_products) do
      add :n_lbs_per_m, :float
      add :p_lbs_per_m, :float
      add :k_lbs_per_m, :float
      add :ca_lbs_per_m, :float
      add :mg_lbs_per_m, :float
      add :s_lbs_per_m, :float
      add :fe_lbs_per_m, :float
      add :mn_lbs_per_m, :float
    end
  end
end
