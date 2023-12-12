defmodule SmolForum.Repo.Migrations.CreateForumPosts do
  use Ecto.Migration

  def change do
    create table(:forum_posts) do
      add :subject, :text
      add :content, :text
      add :author_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:forum_posts, [:author_id])
  end
end
