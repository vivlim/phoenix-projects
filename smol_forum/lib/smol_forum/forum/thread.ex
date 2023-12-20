defmodule SmolForum.Forum.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmolForum.Forum.Board
  alias SmolForum.Forum.Post
  alias SmolForum.Accounts.User
  require Logger

  schema "forum_threads" do
    belongs_to :board, Board
    has_many :posts, Post
    field :subject, :string
    belongs_to :author, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thread, attrs) do
    Logger.debug "thread.changeset: #{inspect(thread)} | #{inspect(attrs)}"
    thread
    #|> SmolForum.Repo.preload(:board)
    |> cast(attrs, [:subject])
    |> validate_required([:subject])
    |> cast_assoc(:board, with: &SmolForum.Forum.Board.changeset/2)
  end
end
