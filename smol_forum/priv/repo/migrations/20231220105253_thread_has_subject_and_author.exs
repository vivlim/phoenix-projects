defmodule SmolForum.Repo.Migrations.ThreadWithFirstPostId do
  use Ecto.Migration

  def change do
    alter table(:forum_threads) do
      add :subject, :text
      add :author_id, references(:users, on_delete: :nothing)
    end
  end
end
