defmodule Manatee.Repo.Migrations.AddDateLocationIdIndexConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:location_weathers, [:location_id, :day], name: :date_location_weather_unique_key)
  end
end
