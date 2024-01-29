defmodule InsiderTradingReportService.Tradings do
  alias InsiderTradingReportService.Tradings.YahooFinanceAPI

  def insider_transactions(ticker) do
    YahooFinanceAPI.insider_transactions(ticker)
  end
end
