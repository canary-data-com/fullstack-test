defmodule InsiderTradingReportServiceWeb.InsidersController do
  use InsiderTradingReportServiceWeb, :controller

  alias InsiderTradingReportService.Insiders

  def index(conn, %{"ticker" => ticker}) do
    insiders_transactions = Insiders.list_insider_transactions_by_ticker(ticker)
    render(conn, :index, insiders_transactions: insiders_transactions)
  end
end
