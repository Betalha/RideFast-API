defmodule RideFastApi.Languages.Lenguage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lenguages" do
    field :code, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lenguage, attrs) do
    lenguage
    |> cast(attrs, [:code, :name])
    |> validate_required([:code, :name])
  end
end
