defmodule RideFastApi.Driver_profiles do
  @moduledoc """
  The Driver_profiles context.
  """

  import Ecto.Query, warn: false
  alias RideFastApi.Repo

  alias RideFastApi.Driver_profiles.Drive_profile

  @doc """
  Returns the list of drive_profiles.

  ## Examples

      iex> list_drive_profiles()
      [%Drive_profile{}, ...]

  """
  def list_drive_profiles do
    Repo.all(Drive_profile)
  end

  @doc """
  Gets a single drive_profile.

  Raises `Ecto.NoResultsError` if the Drive profile does not exist.

  ## Examples

      iex> get_drive_profile!(123)
      %Drive_profile{}

      iex> get_drive_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_drive_profile!(id), do: Repo.get!(Drive_profile, id)

  @doc """
  Creates a drive_profile.

  ## Examples

      iex> create_drive_profile(%{field: value})
      {:ok, %Drive_profile{}}

      iex> create_drive_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_drive_profile(attrs) do
    %Drive_profile{}
    |> Drive_profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a drive_profile.

  ## Examples

      iex> update_drive_profile(drive_profile, %{field: new_value})
      {:ok, %Drive_profile{}}

      iex> update_drive_profile(drive_profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_drive_profile(%Drive_profile{} = drive_profile, attrs) do
    drive_profile
    |> Drive_profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a drive_profile.

  ## Examples

      iex> delete_drive_profile(drive_profile)
      {:ok, %Drive_profile{}}

      iex> delete_drive_profile(drive_profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_drive_profile(%Drive_profile{} = drive_profile) do
    Repo.delete(drive_profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking drive_profile changes.

  ## Examples

      iex> change_drive_profile(drive_profile)
      %Ecto.Changeset{data: %Drive_profile{}}

  """
  def change_drive_profile(%Drive_profile{} = drive_profile, attrs \\ %{}) do
    Drive_profile.changeset(drive_profile, attrs)
  end
end
