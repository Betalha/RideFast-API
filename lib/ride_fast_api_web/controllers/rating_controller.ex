defmodule RideFastApiWeb.RatingController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Ratings
  alias RideFastApi.Rides

  def create(conn, %{"id" => ride_id} = params) do
    case Rides.get_ride(ride_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ride not found"})

      ride ->
        if ride.status == "FINALIZADA" do
          attrs = Map.put(params, "ride_id", ride_id)

          case Ratings.create_rating(attrs) do
            {:ok, rating} ->
              conn
              |> put_status(:created)
              |> json(%{data: rating})

            {:error, changeset} ->
              conn
              |> put_status(:bad_request)
              |> json(%{errors: changeset_errors(changeset)})
          end
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Ride must be FINALIZADA to rate"})
        end
    end
  end

  def index(conn, %{"id" => ride_id}) do
    ratings = Ratings.list_ratings_by_ride(ride_id)
    json(conn, %{data: ratings})
  end

  def show(conn, %{"id" => driver_id}) do
    ratings = Ratings.list_driver_ratings(driver_id)
    json(conn, %{data: ratings})
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
