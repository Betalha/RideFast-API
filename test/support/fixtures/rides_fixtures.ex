defmodule RideFastApi.RidesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFastApi.Rides` context.
  """

  @doc """
  Generate a ride.
  """
  def ride_fixture(attrs \\ %{}) do
    {:ok, ride} =
      attrs
      |> Enum.into(%{
        driver_id: 42,
        endend_at: ~N[2025-12-06 23:51:00],
        final_price: "120.5",
        origen_lat: "120.5",
        origen_lng: "120.5",
        price_estimate: "120.5",
        request_at: ~N[2025-12-06 23:51:00],
        started_at: ~N[2025-12-06 23:51:00],
        status: "some status",
        user_id: 42,
        vehicle_id: 42
      })
      |> RideFastApi.Rides.create_ride()

    ride
  end
end
