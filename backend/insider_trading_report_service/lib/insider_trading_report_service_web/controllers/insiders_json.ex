defmodule InsiderTradingReportServiceWeb.InsidersJSON do
  def index(%{insiders_transactions: insiders_transactions}) do
    insiders_transactions
    |> Enum.map(fn tr ->
      Map.from_struct(tr)
      |> Map.delete(:__meta__)
    end)
  end
end
