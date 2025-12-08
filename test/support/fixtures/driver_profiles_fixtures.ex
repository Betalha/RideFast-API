defmodule RideFastApi.Driver_profilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFastApi.Driver_profiles` context.
  """

  @doc """
  Generate a drive_profile.
  """
  def drive_profile_fixture(attrs \\ %{}) do
    {:ok, drive_profile} =
      attrs
      |> Enum.into(%{
        background_check_ok: true,
        license_expiry: ~D[2025-12-06],
        license_number: "some license_number"
      })
      |> RideFastApi.Driver_profiles.create_drive_profile()

    drive_profile
  end
end
