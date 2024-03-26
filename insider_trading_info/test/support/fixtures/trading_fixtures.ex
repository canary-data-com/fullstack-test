defmodule InsiderTradingInfo.TradingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InsiderTradingInfo.Trading` context.
  """

  @doc """
  Generate a insider_trade.
  """
  def insider_trade_fixture(attrs \\ %{}) do
    {:ok, insider_trade} =
      attrs
      |> Enum.into(%{})
      |> InsiderTradingInfo.Trading.create_insider_trade()

    insider_trade
  end
end
