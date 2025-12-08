defmodule RideFastApi.Rides.Ride do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rides" do
    field :origen_lat, :decimal
    field :origen_lng, :decimal
    field :dest_lat, :decimal
    field :dest_lng, :decimal
    field :price_estimate, :decimal
    field :final_price, :decimal
    field :status, :string
    field :request_at, :naive_datetime
    field :started_at, :naive_datetime
    field :endend_at, :naive_datetime

    belongs_to :user, RideFastApi.Users.User
    belongs_to :driver, RideFastApi.Drivers.Driver
    belongs_to :vehicle, RideFastApi.Vehicles.Vehicle
    has_one :rating, RideFastApi.Ratings.Rating

    timestamps(type: :utc_datetime)
  end

  def changeset(ride, attrs) do
    ride
    |> cast(attrs, [:user_id, :driver_id, :vehicle_id, :origen_lat, :origen_lng, :dest_lat, :dest_lng, :price_estimate, :final_price, :status, :request_at, :started_at, :endend_at])
    |> validate_required([:user_id, :origen_lat, :origen_lng, :dest_lat, :dest_lng])
  end
end
