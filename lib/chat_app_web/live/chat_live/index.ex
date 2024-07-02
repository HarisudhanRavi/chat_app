defmodule ChatAppWeb.ChatLive.Index do
  use ChatAppWeb, :live_view
  alias ChatApp.Account
  alias ChatAppWeb.Presence
  alias Phoenix.PubSub

  @message_topic "messages"
  @presence_topic "presence"

  def mount(_params, %{"current_user" => current_user}, socket) do
    if connected?(socket), do: connected_socket(current_user)

    socket =
      socket
      |> assign(:users, list_users(current_user))
      |> assign(:current_user, current_user)
      |> assign(:selected_user, current_user)
      |> assign(:form_id, 1)
      |> assign(:messages, [])
      |> assign(:viewable_messages, [])
      |> assign(:online_users, online_users())

    {:ok, socket}
  end

  def handle_event("select_user", %{"user_id" => user_id}, socket) do

    user = String.to_integer(user_id) |> Account.get_user!()

    socket =
      socket
      |> assign(:selected_user, user)
      |> assign(:viewable_messages, filter_messages(socket.assigns.messages, socket.assigns.current_user.id, user.id))

    {:noreply, socket}
  end

  def handle_event("send_message", %{"message" => message}, socket) do

    message =
      %{
        message_string: message["msg_text"],
        sender_id: socket.assigns.current_user.id,
        sender_name: socket.assigns.current_user.username,
        receiver_id: socket.assigns.selected_user.id,
        receiver_name: socket.assigns.selected_user.username
      }
    PubSub.broadcast(ChatApp.PubSub, @message_topic, {:message, message})

    socket =
      socket
      |> assign(:form_id, Enum.random(1..50))

    {:noreply, socket}
  end

  def handle_info({:message, message}, socket) do
    if message.sender_id == socket.assigns.current_user.id or message.receiver_id == socket.assigns.current_user.id do

      messages = socket.assigns.messages ++ [message]
      socket =
        socket
        |> assign(:messages, messages)
        |> assign(:viewable_messages, filter_messages(messages, socket.assigns.current_user.id, socket.assigns.selected_user.id))

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    {
      :noreply,
      socket
      |> users_leave(diff.leaves)
      |> users_join(diff.joins)
    }
  end

  defp connected_socket(user) do
    PubSub.subscribe(ChatApp.PubSub, @message_topic)

    {:ok, _} = Presence.track(self(), @presence_topic, user.id, %{
      id: user.id,
      username: user.username
    })

    PubSub.subscribe(ChatApp.PubSub, @presence_topic)
  end

  defp filter_messages(messages, current_user_id, selected_user_id) do

      Enum.filter(messages, fn msg ->
        (msg.sender_id == current_user_id and msg.receiver_id == selected_user_id) or
        (msg.sender_id == selected_user_id and msg.receiver_id == current_user_id)
      end)

  end

  defp users_leave(socket, map) do
    user_ids = Enum.map(map, fn {user_id, _meta} -> String.to_integer(user_id) end)
    assign(socket, :online_users, socket.assigns.online_users -- user_ids)
  end

  defp users_join(socket, map) do
    user_ids = Enum.map(map, fn {user_id, _meta} -> String.to_integer(user_id) end)
    assign(socket, :online_users, socket.assigns.online_users ++ user_ids)
  end

  defp online_users() do
    Presence.list(@presence_topic)
    |> Enum.map(fn {user_id, _meta} -> String.to_integer(user_id) end)
  end

  defp list_users(current_user) do
    [current_user | Account.list_users_without_user(current_user)]
  end

end
