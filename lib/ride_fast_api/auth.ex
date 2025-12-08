defmodule RideFastApi.Auth do
  alias RideFastApi.Users
  alias RideFastApi.Drivers
  alias RideFastApi.Auth.Guardian

  def authenticate(email, password, role) when role in [:user, :driver] do
    with {:ok, resource} <- fetch_by_email(role, email),
         true <- Bcrypt.verify_pass(password, resource.password_hash) do
      Guardian.encode_and_sign({role, resource})
    else
      _ -> {:error, :unauthorized}
    end
  end

  defp fetch_by_email(:user, email) do
    case Users.get_user_by_email(email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  defp fetch_by_email(:driver, email) do
    case Drivers.get_driver_by_email(email) do
      nil -> {:error, :not_found}
      driver -> {:ok, driver}
    end
  end
end
