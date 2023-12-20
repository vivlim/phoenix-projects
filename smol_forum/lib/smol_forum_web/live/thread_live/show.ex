defmodule SmolForumWeb.ThreadLive.Show do
  use SmolForumWeb, :live_view

  alias SmolForum.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    thread = Forum.get_thread!(id)
    {:noreply,
     socket
     |> stream(:posts, Forum.get_thread_posts!(thread.id))
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:thread, thread)
     |> assign(:first_post, List.first(thread.posts))}
  end

  defp page_title(:show), do: "Show Thread"
  defp page_title(:edit), do: "Edit Thread"
end
