defmodule RideFastApi.Repo.Migrations.CreateRides do
  use Ecto.Migration

  def change do
    create table(:rides) do
      add :user_id, :integer
      add :driver_id, :integer
      add :vehicle_id, :integer
      add :origen_lat, :decimal
      add :origen_lng, :decimal
      add :price_estimate, :decimal
      add :final_price, :decimal
      add :status, :string
      add :request_at, :naive_datetime
      add :started_at, :naive_datetime
      add :endend_at, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
