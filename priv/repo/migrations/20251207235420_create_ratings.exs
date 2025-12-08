defmodule RideFastApi.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :ride_id, :integer
      add :from_user_id, :integer
      add :to_driver_id, :integer
      add :score, :integer
      add :comment, :string

      timestamps(type: :utc_datetime)
    end
  end
end
