defmodule PhxBackend.Accounts do
  alias PhxBackend.Repo
  alias PhxBackend.Accounts.{User, Driver}
  import Bcrypt, only: [hash_pwd_salt: 1, verify_pass: 2]

  def register(%{"role" => "user"} = params) do
    params = Map.update!(params, "password", &hash_pwd_salt/1)
    %User{} |> User.changeset(params) |> Repo.insert()
  end

  def register(%{"role" => "driver"} = params) do
    params = Map.update!(params, "password", &hash_pwd_salt/1)
    %Driver{} |> Driver.changeset(params) |> Repo.insert()
  end

  def register(_), do: {:error, %{message: "role must be user or driver"}}

  def authenticate(email, password) do
    cond do
      user = Repo.get_by(User, email: email) ->
        check_password(user, password)

      driver = Repo.get_by(Driver, email: email) ->
        check_password(driver, password)

      true ->
        {:error, :unauthorized}
    end
  end

  defp check_password(resource, password) do
    if verify_pass(password, resource.password_hash) do
      {:ok, resource}
    else
      {:error, :unauthorized}
    end
  end
end
