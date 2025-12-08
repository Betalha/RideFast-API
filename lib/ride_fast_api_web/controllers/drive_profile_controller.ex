defmodule RideFastApiWeb.Drive_profileController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Driver_profiles
  alias RideFastApi.Driver_profiles.Drive_profile

  def index(conn, _params) do
    drive_profiles = Driver_profiles.list_drive_profiles()
    render(conn, :index, drive_profiles: drive_profiles)
  end

  def new(conn, _params) do
    changeset = Driver_profiles.change_drive_profile(%Drive_profile{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"drive_profile" => drive_profile_params}) do
    case Driver_profiles.create_drive_profile(drive_profile_params) do
      {:ok, drive_profile} ->
        conn
        |> put_flash(:info, "Drive profile created successfully.")
        |> redirect(to: ~p"/drive_profiles/#{drive_profile}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    drive_profile = Driver_profiles.get_drive_profile!(id)
    render(conn, :show, drive_profile: drive_profile)
  end

  def edit(conn, %{"id" => id}) do
    drive_profile = Driver_profiles.get_drive_profile!(id)
    changeset = Driver_profiles.change_drive_profile(drive_profile)
    render(conn, :edit, drive_profile: drive_profile, changeset: changeset)
  end

  def update(conn, %{"id" => id, "drive_profile" => drive_profile_params}) do
    drive_profile = Driver_profiles.get_drive_profile!(id)

    case Driver_profiles.update_drive_profile(drive_profile, drive_profile_params) do
      {:ok, drive_profile} ->
        conn
        |> put_flash(:info, "Drive profile updated successfully.")
        |> redirect(to: ~p"/drive_profiles/#{drive_profile}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, drive_profile: drive_profile, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    drive_profile = Driver_profiles.get_drive_profile!(id)
    {:ok, _drive_profile} = Driver_profiles.delete_drive_profile(drive_profile)

    conn
    |> put_flash(:info, "Drive profile deleted successfully.")
    |> redirect(to: ~p"/drive_profiles")
  end
end
