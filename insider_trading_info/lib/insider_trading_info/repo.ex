defmodule InsiderTradingInfo.Repo do
  use Ecto.Repo,
    otp_app: :insider_trading_info,
    adapter: Ecto.Adapters.Postgres
end
