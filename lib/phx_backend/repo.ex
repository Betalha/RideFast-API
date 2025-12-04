defmodule PhxBackend.Repo do
  use Ecto.Repo,
    otp_app: :phx_backend,
    adapter: Ecto.Adapters.MyXQL
end
