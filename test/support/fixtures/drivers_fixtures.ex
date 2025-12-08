defmodule RideFastApi.DriversFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFastApi.Drivers` context.
  """

  @doc """
  Generate a driver.
  """
  def driver_fixture(attrs \\ %{}) do
    {:ok, driver} =
      attrs
      |> Enum.into(%{
        created_at: ~N[2025-12-06 19:02:00],
        email: "some email",
        name: "some name",
        password_hash: "some password_hash",
        phone: "some phone",
        status: "some status"
      })
      |> RideFastApi.Drivers.create_driver()

    driver
  end
end
