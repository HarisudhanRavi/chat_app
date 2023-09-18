defmodule ChatAppWeb.ChatLive.Index do
  use ChatAppWeb, :live_view
  alias ChatApp.Account
  alias Phoenix.PubSub

  def mount(_params, %{"current_user" => current_user}, socket) do
    PubSub.subscribe(ChatApp.PubSub, "messages")

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:selected_user, nil)
      |> assign(:messages, [])
      |> assign(:viewable_messages, [])

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
    PubSub.broadcast(ChatApp.PubSub, "messages", message)

    {:noreply, socket}
  end

  def handle_info(message, socket) do
    IO.inspect(message, label: "recevesfaef")
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

  defp filter_messages(messages, current_user_id, selected_user_id) do

      Enum.filter(messages, fn msg ->
        (msg.sender_id == current_user_id and msg.receiver_id == selected_user_id) or
        (msg.sender_id == selected_user_id and msg.receiver_id == current_user_id)
      end)

  end

end
