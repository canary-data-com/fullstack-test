defmodule InsiderTradingReportServiceWeb.InsiderController do
  use InsiderTradingReportServiceWeb, :controller

  alias InsiderTradingReportService.Tradings

  def show(conn, %{"ticker" => ticker}) do
    json(conn, %{
      data: Tradings.insiders(ticker)
    })
  end

end
