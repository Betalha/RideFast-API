defmodule RideFastApi.Repo.Migrations.CreateDriversLenguages do
  use Ecto.Migration

  def change do
    create table(:drivers_lenguages, primary_key: false) do
      add :driver_id, references(:drivers, on_delete: :delete_all), null: false
      add :lenguage_id, references(:lenguages, on_delete: :delete_all), null: false
    end

    create unique_index(:drivers_lenguages, [:driver_id, :lenguage_id])
  end
end
