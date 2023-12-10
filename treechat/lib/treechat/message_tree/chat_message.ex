defmodule Treechat.MessageTree.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :created, :utc_datetime
    field :author, :id
    field :parent, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:content, :created])
    |> validate_required([:content, :created])
  end
end
