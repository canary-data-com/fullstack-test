defmodule InsiderTradingReportService.Tradings.YahooFinanceAPI do
  def insider_transactions(ticker) do
    HTTPoison.start()
    resp = HTTPoison.get!(url(ticker))
    # TODO Handle errors

    content = resp.body |> Jason.decode!()
    # TODO Handle errors

    content["quoteSummary"]["result"]
    |> Enum.map(fn %{
                     "insiderTransactions" => %{"transactions" => transactions},
                     "summaryDetail" => summary
                   } ->
      {transactions, summary}
    end)
    |> Enum.flat_map(fn {transactions, summary} ->
      transactions
      |> Enum.map(fn transaction ->
        %{
          ticker: ticker,
          name: transaction["filerName"],
          job_title: transaction["filerRelation"],
          startDate: transaction["startDate"]["fmt"],
          shares: transaction["shares"]["raw"],
          amount: transaction["value"]["raw"],
          market_cap: summary["marketCap"]["raw"]
        }
      end)
    end)
  end

  defp url(ticker) do
    "https://query2.finance.yahoo.com/v10/finance/quoteSummary/?symbol=#{ticker}&modules=insiderTransactions,summaryDetail"
  end
end
