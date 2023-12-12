defmodule SmolForum.Forum.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmolForum.Forum.Thread
  require Logger

  schema "forum_boards" do
    field :name, :string
    field :last_post_id, :id
    has_many :threads, Thread

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(board, attrs) do
    Logger.debug "board.changeset: #{inspect(board)} | #{inspect(attrs)}"
    board
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
