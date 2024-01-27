defmodule InsiderTradingReportService.Repo do
  use Ecto.Repo,
    otp_app: :insider_trading_report_service,
    adapter: Ecto.Adapters.Postgres
end
