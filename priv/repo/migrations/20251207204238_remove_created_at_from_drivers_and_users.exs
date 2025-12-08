defmodule RideFastApi.Repo.Migrations.RemoveCreatedAtFromDriversAndUsers do
  use Ecto.Migration

  def change do
    alter table(:drivers) do
      remove :created_at
    end

    alter table(:users) do
      remove :created_at
    end
  end
end
