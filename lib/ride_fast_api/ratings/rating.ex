defmodule RideFastApi.Ratings.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :ride_id, :integer
    field :from_user_id, :integer
    field :to_driver_id, :integer
    field :score, :integer
    field :comment, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:ride_id, :from_user_id, :to_driver_id, :score, :comment])
    |> validate_required([:ride_id, :from_user_id, :to_driver_id, :score, :comment])
  end
end
