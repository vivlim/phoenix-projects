defmodule SmolForum.Forum.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forum_threads" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [])
    |> validate_required([])
  end
end
