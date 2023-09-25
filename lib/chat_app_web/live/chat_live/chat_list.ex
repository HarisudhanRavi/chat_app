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

            <div class="relative w-10 h-10 overflow-hidden bg-green-300 rounded-full">
                <%!-- <svg class="absolute w-12 h-12 text-gray-400 -left-1" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"></path></svg> --%>
                <div class="text-center text-xl pt-1.5"> <%= String.first(user.username) |> String.capitalize() %> </div>
            </div>

            <div class="pl-3">
              <div class="font-medium"><%= user.username %></div>
              <div class="text-xs"><%= "#{user.username}@chat.com" %></div>
            </div>
          </div>
        <% end %>
      </div>

      </div>
    """
  end
end
