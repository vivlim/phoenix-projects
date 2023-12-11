defmodule Treechat.MessageTree do
  require Logger
  require DateTime
  @moduledoc """
  The MessageTree context.
  """

  import Ecto.Query, warn: false
  alias Treechat.Repo

  alias Treechat.MessageTree.ChatMessage

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%ChatMessage{}, ...]

  """
  def list_posts do
    Repo.all(ChatMessage)
    |> Repo.preload(:author)
  end

  @doc """
  Gets a single chat_message.

  Raises `Ecto.NoResultsError` if the Chat message does not exist.

  ## Examples

      iex> get_chat_message!(123)
      %ChatMessage{}

      iex> get_chat_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_message!(id) do
    Repo.get!(ChatMessage, id)
    |> Repo.preload(:author)
  end

  @doc """
  Creates a chat_message.

  ## Examples

      iex> create_chat_message(%{field: value})
      {:ok, %ChatMessage{}}

      iex> create_chat_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_message(attrs \\ %{}) do
    Logger.debug "message_tree.create_chat_message attrs: #{inspect(attrs)}"

    # get the author
    author = Treechat.Accounts.User
    |> Repo.get!(attrs["author"]["id"])

    # create the new message and set its creation time.
    # truncate to nearest second
    %ChatMessage{created: DateTime.utc_now(:second), author_id: author.id, author: author}
    |> ChatMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat_message.

  ## Examples

      iex> update_chat_message(chat_message, %{field: new_value})
      {:ok, %ChatMessage{}}

      iex> update_chat_message(chat_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_message(%ChatMessage{} = chat_message, attrs) do
    chat_message
    |> ChatMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat_message.

  ## Examples

      iex> delete_chat_message(chat_message)
      {:ok, %ChatMessage{}}

      iex> delete_chat_message(chat_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_message(%ChatMessage{} = chat_message) do
    Repo.delete(chat_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat_message changes.

  ## Examples

      iex> change_chat_message(chat_message)
      %Ecto.Changeset{data: %ChatMessage{}}

  """
  def change_chat_message(%ChatMessage{} = chat_message, attrs \\ %{}) do
    ChatMessage.changeset(chat_message, attrs)
  end
end
