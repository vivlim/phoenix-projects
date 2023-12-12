defmodule SmolForum.Repo.Migrations.CreateForumThreads do
  use Ecto.Migration

  def change do
    create table(:forum_threads) do

      timestamps(type: :utc_datetime)
    end
  end
end
