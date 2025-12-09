defmodule RideFastApiWeb.LenguageController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Languages

  def index(conn, _params) do
    languages = Languages.list_lenguages()
    json(conn, %{data: languages})
  end

  def create(conn, params) do
    case Languages.create_lenguage(params) do
      {:ok, language} ->
        conn
        |> put_status(:created)
        |> json(%{data: language})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
