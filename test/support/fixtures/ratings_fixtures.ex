defmodule RideFastApi.RatingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFastApi.Ratings` context.
  """

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    {:ok, rating} =
      attrs
      |> Enum.into(%{
        comment: "some comment",
        from_user_id: 42,
        ride_id: 42,
        score: 42,
        to_driver_id: 42
      })
      |> RideFastApi.Ratings.create_rating()

    rating
  end
end
