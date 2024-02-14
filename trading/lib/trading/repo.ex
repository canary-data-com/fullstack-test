defmodule Trading.Repo do
  use Ecto.Repo,
    otp_app: :trading,
    adapter: Ecto.Adapters.Postgres
end
