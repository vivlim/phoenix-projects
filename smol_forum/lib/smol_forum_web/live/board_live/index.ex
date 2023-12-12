defmodule SmolForumWeb.BoardLive.Index do
  use SmolForumWeb, :live_view

  alias SmolForum.Forum
  alias SmolForum.Forum.Board

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :forum_boards, Forum.list_forum_boards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Board")
    |> assign(:board, Forum.get_board!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Board")
    |> assign(:board, %Board{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Forum boards")
    |> assign(:board, nil)
  end

  @impl true
  def handle_info({SmolForumWeb.BoardLive.FormComponent, {:saved, board}}, socket) do
    {:noreply, stream_insert(socket, :forum_boards, board)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    board = Forum.get_board!(id)
    {:ok, _} = Forum.delete_board(board)

    {:noreply, stream_delete(socket, :forum_boards, board)}
  end
end
