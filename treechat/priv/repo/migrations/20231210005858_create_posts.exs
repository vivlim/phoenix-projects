defmodule Treechat.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :text
      add :created, :utc_datetime
      add :author_id, references(:users, on_delete: :nothing) # name should end with _id to align with ecto schema defaults

      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:author_id])
  end
end
