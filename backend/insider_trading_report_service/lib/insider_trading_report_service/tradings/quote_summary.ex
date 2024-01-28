defmodule InsiderTradingReportService.Tradings.QuoteSummary do

  # https://query2.finance.yahoo.com/v10/finance/quoteSummary/?symbol=AAPL&modules=institutionOwnership,fundOwnership,majorDirectHolders,majorHoldersBreakdown,insiderTransactions,insiderHolders,netSharePurchaseActivity
  # url = ?symbol=AAPL&modules=institutionOwnership,fundOwnership,majorDirectHolders,majorHoldersBreakdown,insiderTransactions,insiderHolders,netSharePurchaseActivity

  def insiders(ticker) do
    HTTPoison.start
    resp = HTTPoison.get!(url(ticker))
    # TODO Handle errors

    content  = resp.body |> Jason.decode!
    # TODO Handle errors

    content["quoteSummary"]["result"]
    |> Enum.flat_map(fn %{"insiderTransactions" => %{"transactions" => transactions}} ->
      transactions  end)
    |> Enum.map(fn transaction ->
      %{
        name: transaction["filerName"],
        job_title: transaction["filerRelation"],
        date: transaction["startDate"]["fmt"],
        shares_amount: transaction["shares"]["raw"],
        amount: transaction["value"]["raw"]
      }
    end)
  end

  defp url(ticker) do
    "https://query2.finance.yahoo.com/v10/finance/quoteSummary/?symbol=#{ticker}&modules=institutionOwnership,fundOwnership,majorDirectHolders,majorHoldersBreakdown,insiderTransactions,insiderHolders,netSharePurchaseActivity"
  end

end
