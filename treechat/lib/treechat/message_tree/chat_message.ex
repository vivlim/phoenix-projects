defmodule Treechat.MessageTree.ChatMessage do
  alias Treechat.Repo
  alias Treechat.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  schema "posts" do
    field :content, :string
    field :created, :utc_datetime
    belongs_to :author, User
    #has_many :parent_msg, ChatMessage, foreign_key: :parent

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: map()
  @doc false
  def changeset(chat_message, attrs) do
    Logger.debug "changeset: {chat_message: #{inspect(chat_message)}, attrs: #{inspect(attrs)}}"
    msg_preloaded = chat_message
    |> Repo.preload(:author)
    Logger.debug "changeset with preloaded msg: #{inspect(msg_preloaded)}"
    c1 = msg_preloaded
    # apply content and created to the chat message
    |> cast(attrs, [:content, :created])
    Logger.debug "changeset after 1st cast: #{inspect(c1)}"
    c2 = c1
    |> cast_assoc(:author, with: &Treechat.Accounts.User.posting_changeset/2) # If we wanted to modify the user as a result of posting, could do this.
    # validate the attrs
    |> validate_required([:content, :created])
    Logger.debug "changeset ret: #{inspect(c2)}"
    c2
  end
end
