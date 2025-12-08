defmodule RideFastApiWeb.AuthController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Auth.Guardian
  alias RideFastApi.Users
  alias RideFastApi.Drivers
  alias RideFastApi.Users.User
  alias RideFastApi.Drivers.Driver

  def register(conn, %{"role" => "user", "name" => name, "email" => email, "phone" => phone, "password" => password}) do
    register_user(conn, %{name: name, email: email, phone: phone, password: password})
  end

  def register(conn, %{"role" => "driver", "name" => name, "email" => email, "phone" => phone, "password" => password}) do
    register_driver(conn, %{name: name, email: email, phone: phone, password: password, status: "ACTIVE"})
  end

  def register(conn, %{"role" => invalid_role}) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid role. Use 'user' or 'driver'", given: invalid_role})
  end

  def register(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing required fields: role, name, email, phone, password"})
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, :user, user} <- authenticate_user(email, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign({:user, user}) do
      conn
      |> put_status(:ok)
      |> json(%{
        token: token,
        user: %{
          id: user.id,
          name: user.name,
          email: user.email,
          role: "user"
        }
      })

    else
      {:ok, :driver, driver} ->
        with {:ok, token, _claims} <- Guardian.encode_and_sign({:driver, driver}) do
          conn
          |> put_status(:ok)
          |> json(%{
            token: token,
            driver: %{
              id: driver.id,
              name: driver.name,
              email: driver.email,
              role: "driver"
            }
          })
        end

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def login(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing email or password"})
  end

  defp register_user(conn, attrs) do
    # Verifica conflito em ambos os contextos
    if email_exists_anywhere(attrs.email) do
      conflict_response(conn)
    else
      case Users.create_user(attrs) do
        {:ok, user} ->
          with {:ok, token, _claims} <- Guardian.encode_and_sign({:user, user}) do
            conn
            |> put_status(:created)
            |> json(%{
              message: "User created successfully",
              token: token,
              user_id: user.id
            })
          end

        {:error, changeset} ->
          bad_request_with_errors(conn, changeset)
      end
    end
  end

  defp register_driver(conn, attrs) do
    if email_exists_anywhere(attrs.email) do
      conflict_response(conn)
    else
      case Drivers.create_driver(attrs) do
        {:ok, driver} ->
          with {:ok, token, _claims} <- Guardian.encode_and_sign({:driver, driver}) do
            conn
            |> put_status(:created)
            |> json(%{
              message: "Driver created successfully",
              token: token,
              driver_id: driver.id
            })
          end

        {:error, changeset} ->
          bad_request_with_errors(conn, changeset)
      end
    end
  end

  defp authenticate_user(email, password) do
    case Users.get_user_by_email(email) do
      %User{} = user when not is_nil(user.password_hash) ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, :user, user}
        else
          {:error, :unauthorized}
        end

      _ ->
        authenticate_driver(email, password)
    end
  end

  defp authenticate_driver(email, password) do
    case Drivers.get_driver_by_email(email) do
      %Driver{} = driver when not is_nil(driver.password_hash) ->
        if Bcrypt.verify_pass(password, driver.password_hash) do
          {:ok, :driver, driver}
        else
          {:error, :unauthorized}
        end

      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_exists_anywhere(email) do
    Users.get_user_by_email(email) != nil or Drivers.get_driver_by_email(email) != nil
  end

  defp conflict_response(conn) do
    conn
    |> put_status(:conflict)
    |> json(%{error: "Email already in use"})
  end

  defp bad_request_with_errors(conn, changeset) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Validation failed", details: traverse_errors(changeset)})
  end

  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
