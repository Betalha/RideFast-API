defmodule RideFastApi.Repo.Migrations.CreateLenguages do
  use Ecto.Migration

  def change do
    create table(:lenguages) do
      add :code, :string
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
