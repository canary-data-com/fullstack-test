defmodule InsiderTradingReportServiceWeb.InsiderController do
  use InsiderTradingReportServiceWeb, :controller

  alias InsiderTradingReportService.Insiders

  def show(conn, %{"ticker" => ticker}) do
    data =
      Insiders.list_insider_transactions_by_ticker(ticker)
      |> Enum.map(fn tr ->
        Map.from_struct(tr)
        |> Map.delete(:__meta__)
      end)

    json(conn, data)
  end
end
