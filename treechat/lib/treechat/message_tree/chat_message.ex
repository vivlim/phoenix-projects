defmodule Treechat.MessageTree.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  schema "posts" do
    field :content, :string
    field :created, :utc_datetime
    field :author, :id
    field :parent, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_message, attrs) do
    Logger.debug "changeset: {chat_message: #{inspect(chat_message)}, attrs: #{inspect(attrs)}}"
    chat_message
    # filter down the set of attrs to the relevant ones
    |> cast(attrs, [:content, :created, :author])
    # validate the attrs
    |> validate_required([:content, :created, :author])
  end
end
