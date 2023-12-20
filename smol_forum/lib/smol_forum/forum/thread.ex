defmodule SmolForum.Forum.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmolForum.Forum.Board
  alias SmolForum.Forum.Post
  require Logger

  schema "forum_threads" do
    belongs_to :board, Board
    has_many :posts, Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thread, attrs) do
    Logger.debug "thread.changeset: #{inspect(thread)} | #{inspect(attrs)}"
    thread
    #|> SmolForum.Repo.preload(:board)
    |> cast(attrs, [])
    |> validate_required([])
    |> cast_assoc(:board, with: &SmolForum.Forum.Board.changeset/2)
  end

  def with_first_post_info(thread) do
    case List.first(thread.posts) do
      nil ->
        Map.merge(thread, %{subject: "nil", author_id: nil})
      first_post ->
        Map.merge(thread, %{subject: first_post.subject, author_id: first_post.author_id})
    end
  end
end
