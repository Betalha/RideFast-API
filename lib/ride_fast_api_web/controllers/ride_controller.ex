defmodule RideFastApiWeb.RideController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Rides
  alias RideFastApi.Rides.Ride

  def index(conn, _params) do
    rides = Rides.list_rides()
    render(conn, :index, rides: rides)
  end

  def new(conn, _params) do
    changeset = Rides.change_ride(%Ride{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"ride" => ride_params}) do
    case Rides.create_ride(ride_params) do
      {:ok, ride} ->
        conn
        |> put_flash(:info, "Ride created successfully.")
        |> redirect(to: ~p"/rides/#{ride}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ride = Rides.get_ride!(id)
    render(conn, :show, ride: ride)
  end

  def edit(conn, %{"id" => id}) do
    ride = Rides.get_ride!(id)
    changeset = Rides.change_ride(ride)
    render(conn, :edit, ride: ride, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ride" => ride_params}) do
    ride = Rides.get_ride!(id)

    case Rides.update_ride(ride, ride_params) do
      {:ok, ride} ->
        conn
        |> put_flash(:info, "Ride updated successfully.")
        |> redirect(to: ~p"/rides/#{ride}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, ride: ride, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ride = Rides.get_ride!(id)
    {:ok, _ride} = Rides.delete_ride(ride)

    conn
    |> put_flash(:info, "Ride deleted successfully.")
    |> redirect(to: ~p"/rides")
  end
end
