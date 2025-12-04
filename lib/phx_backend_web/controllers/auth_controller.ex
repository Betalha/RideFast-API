defmodule PhxBackendWeb.AuthController do
  use PhxBackendWeb, :controller
  alias PhxBackend.Accounts
  alias PhxBackendWeb.Guardian

  def register(conn, params) do
    case Accounts.register(params) do
      {:ok, user_or_driver} ->
        conn
        |> put_status(:created)
        |> json(%{status: "created", data: user_or_driver})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate(email, password) do
      {:ok, user_or_driver} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user_or_driver)

        conn
        |> json(%{
          token: token,
          user: user_or_driver
        })

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "invalid credentials"})
    end
  end
end
