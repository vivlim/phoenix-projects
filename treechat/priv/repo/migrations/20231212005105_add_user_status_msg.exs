defmodule Treechat.Repo.Migrations.AddUserStatusMsg do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :status_msg, :string, null: true
    end
  end
end
