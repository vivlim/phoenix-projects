defmodule SmolForum.Repo.Migrations.ForumHierarchy do
  use Ecto.Migration

  def change do
    alter table(:forum_threads) do
      add :board_id, references(:forum_boards, on_delete: :delete_all)
    end

    alter table(:forum_posts) do
      add :thread_id, references(:forum_threads, on_delete: :delete_all)
    end
  end
end
