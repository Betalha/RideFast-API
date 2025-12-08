defmodule RideFastApi.Repo.Migrations.AddForeignKeys do
  use Ecto.Migration

  def change do
    alter table(:vehicles) do
      modify :driver_id, references(:drivers, on_delete: :delete_all)
    end

    alter table(:rides) do
      modify :user_id, references(:users, on_delete: :nilify_all)
      modify :driver_id, references(:drivers, on_delete: :nilify_all)
      modify :vehicle_id, references(:vehicles, on_delete: :nilify_all)
    end

    alter table(:ratings) do
      modify :ride_id, references(:rides, on_delete: :delete_all)
      modify :from_user_id, references(:users, on_delete: :nilify_all)
      modify :to_driver_id, references(:drivers, on_delete: :nilify_all)
    end
  end
end
