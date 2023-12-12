defmodule SmolForum.Forum.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmolForum.Forum.Board
  alias SmolForum.Forum.Post

  schema "forum_threads" do
    belongs_to :board, Board
    has_many :posts, Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [])
    |> validate_required([])
  end
end
