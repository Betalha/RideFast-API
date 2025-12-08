defmodule RideFastApi.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :plate, :string
    field :model, :string
    field :color, :string
    field :seats, :integer
    field :active, :boolean, default: false

    belongs_to :driver, RideFastApi.Drivers.Driver
    has_many :rides, RideFastApi.Rides.Ride

    timestamps(type: :utc_datetime)
  end

  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:driver_id, :plate, :model, :color, :seats, :active])
    |> validate_required([:plate, :model, :color, :seats])
  end
end
