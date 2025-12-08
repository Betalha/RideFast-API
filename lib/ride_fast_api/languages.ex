defmodule RideFastApi.Languages do
  @moduledoc """
  The Languages context.
  """

  import Ecto.Query, warn: false
  alias RideFastApi.Repo

  alias RideFastApi.Languages.Lenguage

  @doc """
  Returns the list of lenguages.

  ## Examples

      iex> list_lenguages()
      [%Lenguage{}, ...]

  """
  def list_lenguages do
    Repo.all(Lenguage)
  end

  @doc """
  Gets a single lenguage.

  Raises `Ecto.NoResultsError` if the Lenguage does not exist.

  ## Examples

      iex> get_lenguage!(123)
      %Lenguage{}

      iex> get_lenguage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lenguage!(id), do: Repo.get!(Lenguage, id)

  @doc """
  Creates a lenguage.

  ## Examples

      iex> create_lenguage(%{field: value})
      {:ok, %Lenguage{}}

      iex> create_lenguage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lenguage(attrs) do
    %Lenguage{}
    |> Lenguage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lenguage.

  ## Examples

      iex> update_lenguage(lenguage, %{field: new_value})
      {:ok, %Lenguage{}}

      iex> update_lenguage(lenguage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lenguage(%Lenguage{} = lenguage, attrs) do
    lenguage
    |> Lenguage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lenguage.

  ## Examples

      iex> delete_lenguage(lenguage)
      {:ok, %Lenguage{}}

      iex> delete_lenguage(lenguage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lenguage(%Lenguage{} = lenguage) do
    Repo.delete(lenguage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lenguage changes.

  ## Examples

      iex> change_lenguage(lenguage)
      %Ecto.Changeset{data: %Lenguage{}}

  """
  def change_lenguage(%Lenguage{} = lenguage, attrs \\ %{}) do
    Lenguage.changeset(lenguage, attrs)
  end
end
