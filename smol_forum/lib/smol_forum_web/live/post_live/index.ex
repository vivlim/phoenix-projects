defmodule SmolForumWeb.PostLive.Index do
  use SmolForumWeb, :live_view

  alias SmolForum.Forum
  alias SmolForum.Forum.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :forum_posts, Forum.list_forum_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Forum.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Forum posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({SmolForumWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :forum_posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Forum.get_post!(id)
    {:ok, _} = Forum.delete_post(post)

    {:noreply, stream_delete(socket, :forum_posts, post)}
  end
end
