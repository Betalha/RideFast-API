defmodule RideFastApiWeb.DriverLanguageController do
  use RideFastApiWeb, :controller

  import Ecto.Query

  alias RideFastApi.Repo
  alias RideFastApi.DriversLanguages.DriversLanguage

  def create(conn, %{"driver_id" => driver_id} = params) do
    language_id = params["language_id"]
    attrs = %{driver_id: driver_id, language_id: language_id}

    case %DriversLanguage{} |> DriversLanguage.changeset(attrs) |> Repo.insert() do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> json(%{driver_id: driver_id, language_id: language_id})

      {:error, changeset} ->
        conn
        |> put_status(:conflict)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def delete(conn, %{"driver_id" => driver_id, "language_id" => language_id}) do
    query = from dl in DriversLanguage,
      where: dl.driver_id == ^driver_id and dl.language_id == ^language_id

    Repo.delete_all(query)
    send_resp(conn, :no_content, "")
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
