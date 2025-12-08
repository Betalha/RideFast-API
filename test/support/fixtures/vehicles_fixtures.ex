defmodule RideFastApi.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFastApi.Vehicles` context.
  """

  @doc """
  Generate a vehicle.
  """
  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> Enum.into(%{
        active: true,
        color: "some color",
        driver_id: 42,
        model: "some model",
        plate: "some plate",
        seats: 42
      })
      |> RideFastApi.Vehicles.create_vehicle()

    vehicle
  end
end
