defmodule RideFastApi.Rides do
  import Ecto.Query, warn: false
  alias RideFastApi.Repo
  alias RideFastApi.Rides.Ride

  def list_rides(filters \\ %{}) do
    Ride
    |> apply_filters(filters)
    |> Repo.all()
  end

  defp apply_filters(query, filters) do
    Enum.reduce(filters, query, fn
      {"status", status}, query -> where(query, [r], r.status == ^status)
      {"user_id", user_id}, query -> where(query, [r], r.user_id == ^user_id)
      {"driver_id", driver_id}, query -> where(query, [r], r.driver_id == ^driver_id)
      _, query -> query
    end)
  end

  def get_ride(id) do
    Repo.get(Ride, id)
  end

  def get_ride!(id), do: Repo.get!(Ride, id)

  def create_ride(attrs) do
    attrs = Map.put(attrs, "request_at", NaiveDateTime.utc_now())

    %Ride{}
    |> Ride.changeset(attrs)
    |> Repo.insert()
  end

  def update_ride(%Ride{} = ride, attrs) do
    ride
    |> Ride.changeset(attrs)
    |> Repo.update()
  end

  def delete_ride(%Ride{} = ride) do
    Repo.delete(ride)
  end

  def accept_ride(%Ride{} = ride, driver_id, vehicle_id) do
    if ride.status == "SOLICITADA" do
      ride
      |> Ride.changeset(%{driver_id: driver_id, vehicle_id: vehicle_id, status: "ACEITA"})
      |> Repo.update()
    else
      {:error, :invalid_status}
    end
  end

  def start_ride(%Ride{} = ride) do
    if ride.status == "ACEITA" do
      ride
      |> Ride.changeset(%{status: "EM_ANDAMENTO", started_at: NaiveDateTime.utc_now()})
      |> Repo.update()
    else
      {:error, :invalid_status}
    end
  end

  def complete_ride(%Ride{} = ride, final_price) do
    if ride.status == "EM_ANDAMENTO" do
      ride
      |> Ride.changeset(%{status: "FINALIZADA", final_price: final_price, endend_at: NaiveDateTime.utc_now()})
      |> Repo.update()
    else
      {:error, :invalid_status}
    end
  end

  def cancel_ride(%Ride{} = ride) do
    if ride.status in ["SOLICITADA", "ACEITA", "EM_ANDAMENTO"] do
      ride
      |> Ride.changeset(%{status: "CANCELADA"})
      |> Repo.update()
    else
      {:error, :invalid_status}
    end
  end

  def change_ride(%Ride{} = ride, attrs \\ %{}) do
    Ride.changeset(ride, attrs)
  end
end
