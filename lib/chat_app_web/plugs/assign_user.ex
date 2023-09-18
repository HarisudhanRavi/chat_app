defmodule ChatAppWeb.Plugs.AssignUser do
  import Plug.Conn

  def init(_args) do

  end

  def call(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil -> conn
      user ->
        conn
        |> put_session(:current_user, user)
        # |> assign(:current_user, user)
    end
  end
end
