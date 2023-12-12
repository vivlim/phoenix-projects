defmodule SmolForumWeb.ThreadLive.FormComponent do
  use SmolForumWeb, :live_component

  alias SmolForum.Forum

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage thread records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="thread-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Thread</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{thread: thread} = assigns, socket) do
    changeset = Forum.change_thread(thread)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"thread" => thread_params}, socket) do
    changeset =
      socket.assigns.thread
      |> Forum.change_thread(thread_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"thread" => thread_params}, socket) do
    save_thread(socket, socket.assigns.action, thread_params)
  end

  defp save_thread(socket, :edit, thread_params) do
    case Forum.update_thread(socket.assigns.thread, thread_params) do
      {:ok, thread} ->
        notify_parent({:saved, thread})

        {:noreply,
         socket
         |> put_flash(:info, "Thread updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_thread(socket, :new, thread_params) do
    case Forum.create_thread(thread_params) do
      {:ok, thread} ->
        notify_parent({:saved, thread})

        {:noreply,
         socket
         |> put_flash(:info, "Thread created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
