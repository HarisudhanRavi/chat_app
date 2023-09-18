defmodule ChatAppWeb.LoginLive.Index do
  use ChatAppWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:password_visibility, false)
    {:ok, socket}
  end

  def handle_event("toggle_password", _params, socket) do
    {:noreply, assign(socket, :password_visibility, !socket.assigns.password_visibility)}
  end
end
