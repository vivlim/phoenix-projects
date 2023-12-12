defmodule SmolForum.Forum.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forum_boards" do
    field :name, :string
    field :last_post_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
