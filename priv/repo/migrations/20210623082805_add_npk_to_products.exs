defmodule Manatee.Repo.Migrations.AddNpkToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :n_analysis, :float
      add :p_analysis, :float
      add :k_analysis, :float
      add :ca_analysis, :float
      add :mg_analysis, :float
      add :s_analysis, :float
      add :fe_analysis, :float
      add :mn_analysis, :float
    end
  end
end
