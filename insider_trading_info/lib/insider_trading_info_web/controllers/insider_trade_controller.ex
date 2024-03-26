defmodule InsiderTradingInfoWeb.InsiderTradeController do
  @moduledoc """
  The InsiderTradeController is responsible to serve to Insider Trade Info Request
  """
  use InsiderTradingInfoWeb, :controller
  require Logger
  alias InsiderTradingInfoWeb.{InsiderTradeService, RequestValidator, MarketCapInfoService}

  action_fallback InsiderTradingInfoWeb.FallbackController

  @doc """
  Render JSON response of list of Insider Trade Info for company by ticker
  """
  def index(conn, params) do
    with(
      :ok <- RequestValidator.validate_insider_trade_req(params),
      {:result, trades} <- InsiderTradeService.get_insider_trades_by_ticker(params["ticker"]),
      {:ok, [%{market_cap: market_cap, price: share_price}]} <-
        MarketCapInfoService.market_cap(params["ticker"]),
      {:ok, trades_with_market_cap} <-
        InsiderTradeService.add_market_cap_info(market_cap, share_price, trades)
    ) do
      Logger.debug(
        "Fetched Insider Trade Information for #{params["ticker"]}. Total Records Found: #{length(trades_with_market_cap)}"
      )

      render(conn, :index, insider_trades: trades_with_market_cap)
    end
  end

  @doc """
  Render JSON response of list of public companies stored in the database
  """
  def list_company(conn, _params) do
    with {:ok, companies} <- InsiderTradeService.get_company_list() do
      Logger.debug("Fetched Company List. Total Records Found: #{length(companies)}")
      render(conn, :list_company, companies: companies)
    end
  end
end
