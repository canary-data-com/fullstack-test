defmodule InsiderTradingReportServiceWeb.InsidersController do
  use InsiderTradingReportServiceWeb, :controller

  alias InsiderTradingReportServiceWeb.FallbackController
  alias InsiderTradingReportService.Insiders

  action_fallback FallbackController

  def index(conn, %{"ticker" => ticker}) do
    with {:ok, result} <- Insiders.list_insider_transactions_by_ticker(ticker) do
      render(conn, :index, insiders_transactions: result)
    end
  end
end
