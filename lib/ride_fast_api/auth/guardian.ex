defmodule RideFastApi.Auth.Guardian do
  use Guardian, otp_app: :ride_fast_api

  alias RideFastApi.Users
  alias RideFastApi.Drivers

  def subject_for_token({:user, user}, _claims) do
    {:ok, "user:#{user.id}"}
  end

  def subject_for_token({:driver, driver}, _claims) do
    {:ok, "driver:#{driver.id}"}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_role}
  end

  def resource_from_claims(claims) do
    case claims["sub"] do
      "user:" <> id ->
        case Users.get_user(id) do
          nil -> {:error, :user_not_found}
          user -> {:ok, {:user, user}}
        end

      "driver:" <> id ->
        case Drivers.get_driver(id) do
          nil -> {:error, :driver_not_found}
          driver -> {:ok, {:driver, driver}}
        end

      _ ->
        {:error, :invalid_subject}
    end
  end
end
