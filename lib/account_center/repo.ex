defmodule AccountCenter.Repo do
  use Ecto.Repo,
    otp_app: :account_center,
    adapter: Ecto.Adapters.Postgres
end
