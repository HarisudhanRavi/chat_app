defmodule ChatAppWeb.ChatLive.Index do
  use ChatAppWeb, :live_view
  alias ChatAppWeb.Presence
  alias ChatApp.Account
  alias Phoenix.PubSub

  def mount(_params, %{"current_user" => current_user}, socket) do
    PubSub.subscribe(ChatApp.PubSub, "messages")

    {:ok, _} = Presence.track(self(), "messages", current_user.id, %{
      user_id: current_user.id,
      name: current_user.username,
      joined_at: :os.system_time(:seconds)
    })

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:selected_user, current_user)
      |> assign(:form_id, 1)
      |> assign(:messages, [])
      |> assign(:viewable_messages, [])
      |> assign(:online_user_ids, [])
      |> user_joins(Presence.list("messages"))

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
    PubSub.broadcast(ChatApp.PubSub, "messages", {:message_received, message})

    socket =
      socket
      |> assign(:form_id, Enum.random(1..50))

    {:noreply, socket}
  end

  def handle_info({:message_received, message}, socket) do
    if message.sender_id == socket.assigns.current_user.id or message.receiver_id == socket.assigns.current_user.id do

      messages = socket.assigns.messages ++ [message]
      socket =
        socket
        |> assign(:messages, messages)
        |> assign(:viewable_messages, filter_messages(messages, socket.assigns.current_user.id, socket.assigns.selected_user.id))

      socket =
        if message.receiver_id == socket.assigns.current_user.id do
          push_event(socket, "new_message", %{sender_name: message.sender_name, message_string: message.message_string})
        else
          socket
        end
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    {
      :noreply,
      socket
      |> user_leaves(diff.leaves)
      |> user_joins(diff.joins)
    }
  end

  defp user_joins(socket, joins) do
    user_ids = Enum.map(joins, fn {_user_id, %{metas: [meta| _]}} -> meta.user_id end)
    assign(socket, :online_user_ids, socket.assigns.online_user_ids ++ user_ids)
  end

  defp user_leaves(socket, leaves) do
    user_ids = Enum.map(leaves, fn {_user_id, %{metas: [meta| _]}} -> meta.user_id end)
    assign(socket, :online_user_ids, socket.assigns.online_user_ids -- user_ids)
  end

  defp filter_messages(messages, current_user_id, selected_user_id) do

      Enum.filter(messages, fn msg ->
        (msg.sender_id == current_user_id and msg.receiver_id == selected_user_id) or
        (msg.sender_id == selected_user_id and msg.receiver_id == current_user_id)
      end)

  end

end
