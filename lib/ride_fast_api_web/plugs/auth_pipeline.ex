defmodule RideFastApiWeb.Plugs.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ride_fast_api,
    module: RideFastApi.Auth.Guardian,
    error_handler: RideFastApiWeb.Plugs.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: ~w(sub)
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: false
  plug :log_auth

  defp log_auth(conn, _) do
    IO.inspect(conn.req_headers, label: "Headers recebidos")
    IO.inspect(Guardian.Plug.current_token(conn), label: "Token extraído")
    conn
  end
end
