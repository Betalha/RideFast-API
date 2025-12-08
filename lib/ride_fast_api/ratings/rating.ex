defmodule RideFastApi.Ratings.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :score, :integer
    field :comment, :string

    belongs_to :ride, RideFastApi.Rides.Ride
    belongs_to :from_user, RideFastApi.Users.User, foreign_key: :from_user_id
    belongs_to :to_driver, RideFastApi.Drivers.Driver, foreign_key: :to_driver_id

    timestamps(type: :utc_datetime)
  end

  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:ride_id, :from_user_id, :to_driver_id, :score, :comment])
    |> validate_required([:ride_id, :from_user_id, :to_driver_id, :score])
    |> validate_number(:score, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
  end
end
