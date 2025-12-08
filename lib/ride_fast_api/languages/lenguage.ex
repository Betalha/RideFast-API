defmodule RideFastApi.Languages.Lenguage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lenguages" do
    field :code, :string
    field :name, :string

    many_to_many :drivers, RideFastApi.Drivers.Driver, join_through: "drivers_lenguages"

    timestamps(type: :utc_datetime)
  end

  def changeset(lenguage, attrs) do
    lenguage
    |> cast(attrs, [:code, :name])
    |> validate_required([:code, :name])
  end
end
