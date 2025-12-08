defmodule RideFastApi.LanguagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFastApi.Languages` context.
  """

  @doc """
  Generate a lenguage.
  """
  def lenguage_fixture(attrs \\ %{}) do
    {:ok, lenguage} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> RideFastApi.Languages.create_lenguage()

    lenguage
  end
end
