defmodule Trading.InsiderTradingBehaviour do
  @moduledoc """
  Insider Trading Behaviour Module
  """
  @callback http_get(String.t(), []) :: {:ok, any()} | {:error, any()}
end
