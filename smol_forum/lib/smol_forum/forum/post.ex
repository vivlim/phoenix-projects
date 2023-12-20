defmodule SmolForum.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmolForum.Forum.Thread
  alias SmolForum.Accounts.User

  schema "forum_posts" do
    field :content, :string
    field :subject, :string
    belongs_to :author, User

    belongs_to :thread, Thread

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    #|> SmolForum.Repo.preload(:thread)
    |> cast(attrs, [:subject, :content])
    |> validate_required([:subject, :content])
    |> cast_assoc(:thread, with: &SmolForum.Forum.Thread.changeset/2)
  end
end
