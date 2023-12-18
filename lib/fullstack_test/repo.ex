defmodule FullstackTest.Repo do
  use Ecto.Repo,
    otp_app: :fullstack_test,
    adapter: Ecto.Adapters.Postgres
end
