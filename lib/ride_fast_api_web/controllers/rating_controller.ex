defmodule RideFastApiWeb.RatingController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Ratings
  alias RideFastApi.Ratings.Rating

  def index(conn, _params) do
    ratings = Ratings.list_ratings()
    render(conn, :index, ratings: ratings)
  end

  def new(conn, _params) do
    changeset = Ratings.change_rating(%Rating{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"rating" => rating_params}) do
    case Ratings.create_rating(rating_params) do
      {:ok, rating} ->
        conn
        |> put_flash(:info, "Rating created successfully.")
        |> redirect(to: ~p"/ratings/#{rating}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rating = Ratings.get_rating!(id)
    render(conn, :show, rating: rating)
  end

  def edit(conn, %{"id" => id}) do
    rating = Ratings.get_rating!(id)
    changeset = Ratings.change_rating(rating)
    render(conn, :edit, rating: rating, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rating" => rating_params}) do
    rating = Ratings.get_rating!(id)

    case Ratings.update_rating(rating, rating_params) do
      {:ok, rating} ->
        conn
        |> put_flash(:info, "Rating updated successfully.")
        |> redirect(to: ~p"/ratings/#{rating}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, rating: rating, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rating = Ratings.get_rating!(id)
    {:ok, _rating} = Ratings.delete_rating(rating)

    conn
    |> put_flash(:info, "Rating deleted successfully.")
    |> redirect(to: ~p"/ratings")
  end
end
