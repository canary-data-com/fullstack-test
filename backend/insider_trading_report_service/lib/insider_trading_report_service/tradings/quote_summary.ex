defmodule InsiderTradingReportService.Tradings.QuoteSummary do
  def insiders(ticker) do
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
          market_cap: summary["marketCap"]["raw"],
          market_cap_percentage:
            calculate_market_cap_percentage(
              transaction["value"]["raw"],
              summary["marketCap"]["raw"]
            )
        }
      end)
    end)
  end

  defp url(ticker) do
    "https://query2.finance.yahoo.com/v10/finance/quoteSummary/?symbol=#{ticker}&modules=insiderTransactions,summaryDetail"
  end

  defp calculate_market_cap_percentage(nil, nil), do: nil

  defp calculate_market_cap_percentage(nil, _market_cap), do: nil

  defp calculate_market_cap_percentage(_amount, nil), do: nil

  defp calculate_market_cap_percentage(amount, market_cap) do
    result = amount / market_cap * 100
    Float.ceil(result, 4)
  end
end
