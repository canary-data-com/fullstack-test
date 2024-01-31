defmodule InsiderTradingReportService.Tradings.YahooFinanceAPI do
  require Logger

  alias InsiderTradingReportService.IntegrationLogs
  alias InsiderTradingReportService.IntegrationLogs.IntegrationLog

  def insider_transactions(ticker) do
    Logger.info("Starting calling Yahoo API...")
    endpoint = url(ticker)
    HTTPoison.start()

    with {:ok, %{status_code: 200, body: body}} <- HTTPoison.get(endpoint),
         {:ok, content} <- Jason.decode(body),
         {:ok, _} <-
           IntegrationLogs.create_integration_log(%{
             integration_type: "http",
             endpoint: endpoint,
             status: to_string(200),
             tags: IntegrationLog.insider_transactions_tags()
           }) do
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
