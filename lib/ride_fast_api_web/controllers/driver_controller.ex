defmodule RideFastApiWeb.DriverController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Drivers

  def index(conn, params) do
    drivers = Drivers.list_drivers_filtered(params)
    json(conn, %{data: drivers})
  end

  def drives_languages_index(conn, %{"driver_id" => driver_id}) do
    languages = Drivers.get_languages_by_driver(driver_id)
    json(conn, %{data: languages})
  end

  def show(conn, %{"id" => id}) do
    case Drivers.get_driver(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Driver not found"})

      driver ->
        json(conn, %{data: driver})
    end
  end

  def create(conn, params) do
    attrs = Map.put_new(params, "status", "ACTIVE")

    case Drivers.create_driver(attrs) do
      {:ok, driver} ->
        conn
        |> put_status(:created)
        |> json(%{data: driver})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Drivers.get_driver(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Driver not found"})

      driver ->
        case Drivers.update_driver(driver, params) do
          {:ok, updated_driver} ->
            json(conn, %{data: updated_driver})

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{errors: changeset_errors(changeset)})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Drivers.get_driver(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Driver not found"})

      driver ->
        Drivers.delete_driver(driver)
        send_resp(conn, :no_content, "")
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
