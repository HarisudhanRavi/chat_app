defmodule ChatAppWeb.Plugs.AuthErrorHandler do
  # import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)

    conn
    |> Phoenix.Controller.put_flash(:error, body)
    |> Phoenix.Controller.redirect(to: "/login")
  end

end
