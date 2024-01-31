defmodule InsiderTradingReportServiceWeb.InsidersJSON do
  alias InsiderTradingReportService.Insiders.InsiderTransaction

  def index(%{insiders_transactions: insiders_transactions}) do
    insiders_transactions
    |> Enum.map(&InsiderTransaction.to_map(&1, true))
  end
end
