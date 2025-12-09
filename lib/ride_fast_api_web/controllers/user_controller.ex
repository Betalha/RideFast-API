defmodule RideFastApiWeb.UserController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Users

  def index(conn, _params) do
    users = Users.list_users()
    json(conn, %{data: users})
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        json(conn, %{data: user})
    end
  end

  def create(conn, params) do
    case Users.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{data: user})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Users.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        case Users.update_user(user, params) do
          {:ok, updated_user} ->
            json(conn, %{data: updated_user})

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{errors: changeset_errors(changeset)})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        Users.delete_user(user)
        send_resp(conn, :no_content, "")
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
