defmodule RideFastApi.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :name, :string
      add :email, :string
      add :phone, :string
      add :password_hash, :string
      add :status, :string
      add :created_at, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
