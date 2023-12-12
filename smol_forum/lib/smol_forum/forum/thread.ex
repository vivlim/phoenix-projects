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
end
