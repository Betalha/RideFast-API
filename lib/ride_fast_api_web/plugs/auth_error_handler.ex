defmodule RideFastApiWeb.Plugs.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = case type do
      :unauthenticated -> "Token ausente ou inválido"
      :unauthorized -> "Acesso não autorizado"
      _ -> "Erro de autenticação"
    end

    conn
    |> put_status(401)
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: body}))
    |> halt()
  end
end
