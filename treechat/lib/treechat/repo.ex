defmodule Treechat.Repo do
  use Ecto.Repo,
    otp_app: :treechat,
    adapter: Ecto.Adapters.SQLite3
end
