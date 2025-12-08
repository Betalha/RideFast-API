defmodule RideFastApi.Rides.Ride do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rides" do
    field :user_id, :integer
    field :driver_id, :integer
    field :vehicle_id, :integer
    field :origen_lat, :decimal
    field :origen_lng, :decimal
    field :price_estimate, :decimal
    field :final_price, :decimal
    field :status, :string
    field :request_at, :naive_datetime
    field :started_at, :naive_datetime
    field :endend_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ride, attrs) do
    ride
    |> cast(attrs, [:user_id, :driver_id, :vehicle_id, :origen_lat, :origen_lng, :price_estimate, :final_price, :status, :request_at, :started_at, :endend_at])
    |> validate_required([:user_id, :driver_id, :vehicle_id, :origen_lat, :origen_lng, :price_estimate, :final_price, :status, :request_at, :started_at, :endend_at])
  end
end
