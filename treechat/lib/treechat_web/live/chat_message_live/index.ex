defmodule TreechatWeb.ChatMessageLive.Index do
  use TreechatWeb, :live_view

  alias Treechat.MessageTree
  alias Treechat.MessageTree.ChatMessage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :posts, MessageTree.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chat message")
    |> assign(:chat_message, MessageTree.get_chat_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chat message")
    |> assign(:chat_message, %ChatMessage{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:chat_message, nil)
  end

  @impl true
  def handle_info({TreechatWeb.ChatMessageLive.FormComponent, {:saved, chat_message}}, socket) do
    {:noreply, stream_insert(socket, :posts, chat_message)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat_message = MessageTree.get_chat_message!(id)
    {:ok, _} = MessageTree.delete_chat_message(chat_message)

    {:noreply, stream_delete(socket, :posts, chat_message)}
  end
end
