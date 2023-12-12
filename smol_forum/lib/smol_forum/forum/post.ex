defmodule SmolForum.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forum_posts" do
    field :content, :string
    field :subject, :string
    field :author_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:subject, :content])
    |> validate_required([:subject, :content])
  end
end
