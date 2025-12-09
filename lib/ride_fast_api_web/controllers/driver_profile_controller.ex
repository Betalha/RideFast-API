defmodule RideFastApiWeb.DriverProfileController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Driver_profiles

  def show(conn, %{"driver_id" => driver_id}) do
    case Driver_profiles.get_profile_by_driver(driver_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})

      profile ->
        json(conn, %{data: profile})
    end
  end

  def create(conn, %{"driver_id" => driver_id} = params) do
    case Driver_profiles.get_profile_by_driver(driver_id) do
      nil ->
        attrs = Map.put(params, "driver_id", driver_id)

        case Driver_profiles.create_drive_profile(attrs) do
          {:ok, profile} ->
            conn
            |> put_status(:created)
            |> json(%{data: profile})

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{errors: changeset_errors(changeset)})
        end

      _existing ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Profile already exists for this driver"})
    end
  end

  def update(conn, %{"driver_id" => driver_id} = params) do
    case Driver_profiles.get_profile_by_driver(driver_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})

      profile ->
        case Driver_profiles.update_drive_profile(profile, params) do
          {:ok, updated_profile} ->
            json(conn, %{data: updated_profile})

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{errors: changeset_errors(changeset)})
        end
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
