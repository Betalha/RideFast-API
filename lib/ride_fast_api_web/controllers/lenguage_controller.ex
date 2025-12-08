defmodule RideFastApiWeb.LenguageController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Languages
  alias RideFastApi.Languages.Lenguage

  def index(conn, _params) do
    lenguages = Languages.list_lenguages()
    render(conn, :index, lenguages: lenguages)
  end

  def new(conn, _params) do
    changeset = Languages.change_lenguage(%Lenguage{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"lenguage" => lenguage_params}) do
    case Languages.create_lenguage(lenguage_params) do
      {:ok, lenguage} ->
        conn
        |> put_flash(:info, "Lenguage created successfully.")
        |> redirect(to: ~p"/lenguages/#{lenguage}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lenguage = Languages.get_lenguage!(id)
    render(conn, :show, lenguage: lenguage)
  end

  def edit(conn, %{"id" => id}) do
    lenguage = Languages.get_lenguage!(id)
    changeset = Languages.change_lenguage(lenguage)
    render(conn, :edit, lenguage: lenguage, changeset: changeset)
  end

  def update(conn, %{"id" => id, "lenguage" => lenguage_params}) do
    lenguage = Languages.get_lenguage!(id)

    case Languages.update_lenguage(lenguage, lenguage_params) do
      {:ok, lenguage} ->
        conn
        |> put_flash(:info, "Lenguage updated successfully.")
        |> redirect(to: ~p"/lenguages/#{lenguage}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, lenguage: lenguage, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lenguage = Languages.get_lenguage!(id)
    {:ok, _lenguage} = Languages.delete_lenguage(lenguage)

    conn
    |> put_flash(:info, "Lenguage deleted successfully.")
    |> redirect(to: ~p"/lenguages")
  end
end
