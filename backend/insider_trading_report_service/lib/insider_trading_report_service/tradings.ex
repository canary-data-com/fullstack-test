defmodule InsiderTradingReportService.Tradings do
  alias InsiderTradingReportService.Tradings.QuoteSummary

  def insiders(ticker) do
    QuoteSummary.insiders(ticker)
  end
end
