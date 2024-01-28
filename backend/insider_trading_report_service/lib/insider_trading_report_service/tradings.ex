defmodule InsiderTradingReportService.Tradings do

  alias InsiderTradingReportService.Tradings.QuoteSummary

  def insiders(ticker) do
    # the person who did the transaction, job title,
    #the date and the amount of shares.

    #and how much in percentage of the market cap that represents.
    QuoteSummary.insiders(ticker)
  end

end
