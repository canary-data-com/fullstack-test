defmodule InsiderTradingInfoWeb.InsiderTradeService do
  @moduledoc """
  The InsiderTradeService used for preparing response for request of InsiderTradeController
  """
  require Logger
  alias InsiderTradingInfo.Trading

  @doc """
  Get Insider Trades for ticker
  """
  def get_insider_trades_by_ticker(ticker) do
    with {:ok, trades} <- Trading.get_insider_trade_info_by_ticker(ticker) do
      {:result, trades}
    else
      error ->
        Logger.error(
          "Something went wrong while fetching data of insider trade by ticker. reason: #{inspect(error)}}"
        )

        {:error, "Something went wrong while fetching data."}
    end
  end

  @doc """
  Get Company List
  """
  def get_company_list() do
    Trading.company_list()
  end

  def add_market_cap_info(market_cap, share_price, insider_trades) do
    updated_list =
      Enum.map(insider_trades, fn trade ->
        %{
          person_name: trade.person_name,
          job_title: trade.job_title,
          trade_date: trade.transaction_date,
          share_qty: trade.share_qty,
          market_cap_percentage:
            calculate_market_cap_percentage(trade.share_qty, share_price, market_cap)
        }
      end)

    Logger.debug("Updated Insider trade list with market cap information")
    {:ok, updated_list}
  end

  defp calculate_market_cap_percentage(shares, share_price, total_market_cap) do
    market_cap_percentage = shares * share_price / total_market_cap * 100
    :erlang.float_to_binary(market_cap_percentage, [:compact, {:decimals, 6}])
  end
end
