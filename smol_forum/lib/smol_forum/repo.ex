defmodule SmolForum.Repo do
  use Ecto.Repo,
    otp_app: :smol_forum,
    adapter: Ecto.Adapters.SQLite3
end
