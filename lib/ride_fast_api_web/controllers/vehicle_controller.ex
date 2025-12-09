defmodule RideFastApiWeb.VehicleController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Vehicles

  def index(conn, %{"driver_id" => driver_id}) do
    vehicles = Vehicles.list_vehicles_by_driver(driver_id)
    json(conn, %{data: vehicles})
  end

  def create(conn, %{"driver_id" => driver_id} = params) do
    attrs = Map.put(params, "driver_id", driver_id)

    case Vehicles.create_vehicle(attrs) do
      {:ok, vehicle} ->
        conn
        |> put_status(:created)
        |> json(%{data: vehicle})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Vehicles.get_vehicle(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Vehicle not found"})

      vehicle ->
        case Vehicles.update_vehicle(vehicle, params) do
          {:ok, updated_vehicle} ->
            json(conn, %{data: updated_vehicle})

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{errors: changeset_errors(changeset)})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Vehicles.get_vehicle(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Vehicle not found"})

      vehicle ->
        Vehicles.delete_vehicle(vehicle)
        send_resp(conn, :no_content, "")
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
