defmodule ChatAppWeb.ChatLive.ChatList do
  use ChatAppWeb, :live_component

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  defp selected_user_class(nil, _user), do: " bg-gray-100 hover:bg-gray-400"
  defp selected_user_class(selected_user, user) do
    if selected_user.id == user.id do
      " bg-gray-400"
    else
      " bg-gray-100 hover:bg-gray-400"
    end
  end

  def render(assigns) do
    ~H"""
      <div>
        <div>Chat list</div>

      <div class="w-64">
        <%= for user <- @users do %>
          <div phx-click="select_user" phx-value-user_id={user.id} class={"flex w-full h-16 pt-2 pl-2 cursor-pointer border-b-[1px]" <> selected_user_class(@selected_user, user)}>

            <div class="relative w-10 h-10 overflow-visible bg-gray-200 rounded-full">
                <div class="text-center text-xl pt-1.5"> <%= String.first(user.username) |> String.capitalize() %> </div>
                <%= if user.id in @online_users do %>
                <span class="bottom-0 left-7 absolute z-100 w-2.5 h-2.5 bg-green-500 rounded-full"></span>
                <% else %>
                <span class="bottom-0 left-7 absolute z-100 w-2.5 h-2.5 bg-red-600 rounded-full"></span>
                <% end %>
            </div>

            <div class="pl-3">
              <span class="font-medium"><%= user.username %></span>
              <%= if user == @current_user do %>
              <span>(You)</span>
              <% end %>
              <div class="text-xs"><%= "#{user.username}@chat.com" %></div>
            </div>
          </div>
        <% end %>
      </div>

      </div>
    """
  end
end
