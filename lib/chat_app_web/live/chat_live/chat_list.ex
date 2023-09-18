defmodule ChatAppWeb.ChatLive.ChatList do
  use ChatAppWeb, :live_component
  alias ChatApp.Account

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:users, list_users())

    {:ok, socket}
  end

  defp list_users() do
    Account.list_users()
  end

  def render(assigns) do
    ~H"""
      <div>
        <div>Chat list</div>

        <div>
            <%= for user <- @users do %>
              <div phx-click="select_user" phx-value-user_id={user.id}>
                <%= user.username %>
              </div>
            <% end %>
        </div>

      </div>
    """
  end
end
