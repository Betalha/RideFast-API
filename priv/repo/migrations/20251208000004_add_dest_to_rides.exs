defmodule RideFastApi.Repo.Migrations.AddDestToRides do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add :dest_lat, :decimal
      add :dest_lng, :decimal
    end
  end
end
