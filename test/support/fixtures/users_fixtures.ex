defmodule RideFastApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFastApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        created_at: ~N[2025-12-04 23:50:00],
        email: "some email",
        name: "some name",
        password_hash: "some password_hash",
        phone: "some phone"
      })
      |> RideFastApi.Users.create_user()

    user
  end
end
