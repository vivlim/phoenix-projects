defmodule SmolForum.Repo.Migrations.CreateForumBoards do
  use Ecto.Migration

  def change do
    create table(:forum_boards) do
      add :name, :string
      add :last_post_id, references(:forum_posts, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:forum_boards, [:last_post_id])
  end
end
