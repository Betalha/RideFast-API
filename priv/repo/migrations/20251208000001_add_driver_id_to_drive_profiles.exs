defmodule RideFastApi.Repo.Migrations.AddDriverIdToDriveProfiles do
  use Ecto.Migration

  def change do
    alter table(:drive_profiles) do
      add :driver_id, references(:drivers, on_delete: :delete_all), null: false
    end

    create unique_index(:drive_profiles, [:driver_id])
  end
end
