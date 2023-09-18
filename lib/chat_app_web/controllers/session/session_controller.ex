defmodule ChatAppWeb.Session.SessionController do
  use ChatAppWeb, :controller
  alias ChatApp.Account

  def login(conn, %{"login" => login_params}) do
    %{"username" => username, "password" => password} = login_params

    case authenticate_user(username, password) do
      {:ok, user} ->
        ChatApp.Guardian.Plug.sign_in(conn, user)
        |> configure_session(renew: true)
        |> put_flash(:info, "Logged in successfully")
        |> redirect(to: "/chat_live")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)

    end
  end

  def logout(conn, _params) do
    ChatApp.Guardian.Plug.sign_out(conn)
    |> renew_session()
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: "/login")
  end

  def authenticate_user(username, password) do
    case Account.get_user_by_username(username) do
      nil ->
        {:error, "invalid_user"}

      user ->
        verify_password(user, password)
    end
  end

  defp verify_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "invalid_credentials"}
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
