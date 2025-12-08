defmodule RideFastApi.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :driver_id, :integer
      add :plate, :string
      add :model, :string
      add :color, :string
      add :seats, :integer
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
