defmodule RideFastApiWeb.Plugs.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ride_fast_api,
    module: RideFastApi.Auth.Guardian,
    error_handler: RideFastApiWeb.Plugs.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
end
