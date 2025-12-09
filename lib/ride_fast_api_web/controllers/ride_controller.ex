defmodule RideFastApiWeb.RideController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Rides

  def index(conn, params) do
    rides = Rides.list_rides(params)
    json(conn, %{data: rides})
  end

  def show(conn, %{"id" => id}) do
    case Rides.get_ride(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ride not found"})

      ride ->
        json(conn, %{data: format_ride(ride)})
    end
  end

  def create(conn, params) do
    origin_lat = params["origin_lat"] || get_in(params, ["origin", "lat"]) || "0"
    origin_lng = params["origin_lng"] || get_in(params, ["origin", "lng"]) || "0"
    dest_lat = params["dest_lat"] || get_in(params, ["destination", "lat"]) || "0"
    dest_lng = params["dest_lng"] || get_in(params, ["destination", "lng"]) || "0"

    attrs = %{
      "user_id" => params["user_id"],
      "origen_lat" => origin_lat,
      "origen_lng" => origin_lng,
      "dest_lat" => dest_lat,
      "dest_lng" => dest_lng,
      "price_estimate" => params["price_estimate"] || params["estimated_price"],
      "status" => "SOLICITADA",
      "request_at" => NaiveDateTime.utc_now()
    }

    case Rides.create_ride(attrs) do
      {:ok, ride} ->
        conn
        |> put_status(:created)
        |> json(%{data: format_ride(ride)})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Rides.get_ride(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ride not found"})

      ride ->
        Rides.delete_ride(ride)
        send_resp(conn, :no_content, "")
    end
  end

  def accept(conn, %{"id" => id} = params) do
    driver_id = params["driver_id"]
    vehicle_id = params["vehicle_id"] || 1

    case Rides.get_ride(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ride not found"})

      ride ->
        case Rides.accept_ride(ride, driver_id, vehicle_id) do
          {:ok, updated_ride} ->
            json(conn, %{data: format_ride(updated_ride)})

          {:error, :invalid_status} ->
            conn
            |> put_status(:conflict)
            |> json(%{error: "Ride already accepted or invalid status"})
        end
    end
  end

  def start(conn, %{"id" => id}) do
    case Rides.get_ride(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ride not found"})

      ride ->
        case Rides.start_ride(ride) do
          {:ok, updated_ride} ->
            json(conn, %{data: format_ride(updated_ride)})

          {:error, :invalid_status} ->
            conn
            |> put_status(:conflict)
            |> json(%{error: "Ride must be ACEITA to start"})
        end
    end
  end

  def complete(conn, %{"id" => id} = params) do
    final_price = params["final_price"] || 0

    case Rides.get_ride(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ride not found"})

      ride ->
        case Rides.complete_ride(ride, final_price) do
          {:ok, updated_ride} ->
            json(conn, %{data: format_ride(updated_ride)})

          {:error, :invalid_status} ->
            conn
            |> put_status(:conflict)
            |> json(%{error: "Ride must be EM_ANDAMENTO to complete"})
        end
    end
  end

  def cancel(conn, %{"id" => id}) do
    case Rides.get_ride(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ride not found"})

      ride ->
        case Rides.cancel_ride(ride) do
          {:ok, updated_ride} ->
            json(conn, %{data: format_ride(updated_ride)})

          {:error, :invalid_status} ->
            conn
            |> put_status(:conflict)
            |> json(%{error: "Ride cannot be cancelled"})
        end
    end
  end

  def history(conn, %{"id" => _id}) do
    json(conn, %{data: []})
  end

  defp format_ride(ride) do
    %{
      id: ride.id,
      user_id: ride.user_id,
      driver_id: ride.driver_id,
      vehicle_id: ride.vehicle_id,
      origin: %{lat: ride.origen_lat, lng: ride.origen_lng},
      destination: %{lat: ride.dest_lat, lng: ride.dest_lng},
      price_estimate: ride.price_estimate,
      final_price: ride.final_price,
      status: ride.status,
      requested_at: ride.request_at,
      started_at: ride.started_at,
      ended_at: ride.endend_at
    }
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
