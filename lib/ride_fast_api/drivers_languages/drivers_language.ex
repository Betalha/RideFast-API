defmodule RideFastApi.DriversLanguages.DriversLanguage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "drivers_lenguages" do
    field :driver_id, :integer, primary_key: true
    field :language_id, :integer, source: :lenguage_id, primary_key: true
  end

  def changeset(drivers_language, attrs) do
    drivers_language
    |> cast(attrs, [:driver_id, :language_id])
    |> validate_required([:driver_id, :language_id])
    |> unique_constraint([:driver_id, :language_id])
  end
end
