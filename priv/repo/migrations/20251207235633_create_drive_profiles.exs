defmodule RideFastApi.Repo.Migrations.CreateDriveProfiles do
  use Ecto.Migration

  def change do
    create table(:drive_profiles) do
      add :license_number, :string
      add :license_expiry, :date
      add :background_check_ok, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
