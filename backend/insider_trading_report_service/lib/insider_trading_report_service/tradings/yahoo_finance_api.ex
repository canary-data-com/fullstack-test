defmodule InsiderTradingReportService.Tradings.YahooFinanceAPI do
  require Logger

  def insider_transactions(ticker) do
    Logger.info("Starting calling Yahoo API...")
    HTTPoison.start()

    with {:ok, %{status_code: 200, body: body}} <- HTTPoison.get(url(ticker)),
         {:ok, content} <- Jason.decode(body) do
      result =
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

      {:ok, result}
    else
      {:ok, %{status_code: 404}} ->
        message = "Ticker #{ticker} Not Found."
        Logger.warning(message)
        {:error, message}

      _ ->
        Logger.error("Error calling Yahoo API...")
        {:error, :internal_server_error}
    end
  end

  defp url(ticker) do
    "https://query2.finance.yahoo.com/v10/finance/quoteSummary/?symbol=#{ticker}&modules=insiderTransactions,summaryDetail"
  end
end
