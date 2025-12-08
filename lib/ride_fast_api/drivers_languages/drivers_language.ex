defmodule RideFastApi.DriversLanguages.DriversLanguage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "drivers_lenguages" do
    belongs_to :driver, RideFastApi.Drivers.Driver, foreign_key: :driver_id
    belongs_to :language, RideFastApi.Languages.Lenguage, foreign_key: :lenguage_id

    timestamps(type: :utc_datetime)
  end

  def changeset(drivers_language, attrs) do
    drivers_language
    |> cast(attrs, [:driver_id, :language_id])
    |> validate_required([:driver_id, :language_id])
    |> unique_constraint([:driver_id, :language_id])
  end
end
