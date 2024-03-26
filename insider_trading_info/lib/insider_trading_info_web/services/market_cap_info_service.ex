defmodule InsiderTradingInfoWeb.MarketCapInfoService do
  @moduledoc """
  The MarketCapInfoService used for getting market cap info by ticker using Yahoo Finance API
  """
  require Logger

  @doc """
  Get Market Cap Info for company by ticker
  """
  def market_cap(ticker) do
    endpoint =
      Application.get_env(:insider_trading_info, :market_cap_url_template)
      |> String.replace("%t", ticker)

    with {:ok, %{status_code: 200, body: body}} <- HTTPoison.get(endpoint),
         {:ok, content} <- Jason.decode(body) do
      result =
        content["quoteSummary"]["result"]
        |> Enum.map(fn summary ->
          %{
            ticker: ticker,
            market_cap: summary["summaryDetail"]["marketCap"]["raw"],
            price: summary["summaryDetail"]["open"]["raw"]
          }
        end)

      Logger.debug("Market Cap Info: #{inspect(result)}")
      {:ok, result}
    else
      error ->
        Logger.error(
          "Something went wrong while calling Market Cap API. Reason: #{inspect(error)}"
        )

        {:error, :internal_server_error}
    end
  end
end
