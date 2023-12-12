defmodule SmolForumWeb.BoardLive.Show do
  use SmolForumWeb, :live_view

  alias SmolForum.Forum
  alias SmolForum.Forum.Board
  alias SmolForum.Forum.Thread
  alias SmolForum.Forum.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Board")
    |> assign(:board, Forum.get_board!(id))
  end

  defp apply_action(socket, :new_thread, %{"id" => id}) do
    board = Forum.get_board!(id)
    thread = %Thread{board: board}
    post = %Post{thread: thread}
    socket
    |> assign(:page_title, "New thread")
    |> assign(:board, board)
    |> assign(:post, post)
  end

  defp apply_action(socket, _, %{"id" => id}) do
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:board, Forum.get_board!(id))
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:edit), do: "Edit Board"
  defp page_title(:new_thread), do: "New thread"
end
