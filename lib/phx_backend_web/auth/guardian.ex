defmodule PhxBackendWeb.Guardian do
  use Guardian, otp_app: :phx_backend
  alias PhxBackend.Accounts

  def subject_for_token(resource, _claims) do
    {:ok, "#{resource.id}:#{resource.__struct__}"}
  end

  def resource_from_claims(%{"sub" => sub}) do
    [id, module] = String.split(sub, ":")

    resource =
      case module do
        "Elixir.PhxBackend.Accounts.User" ->
          Accounts.get_user!(id)

        "Elixir.PhxBackend.Accounts.Driver" ->
          Accounts.get_driver!(id)
      end

    {:ok, resource}
  end
end
