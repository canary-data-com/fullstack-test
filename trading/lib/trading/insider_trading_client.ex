defmodule Trading.InsiderTradingClient do
  @moduledoc """
  Insider Trading Client Module
  """
  @behaviour Trading.InsiderTradingBehaviour

  def http_get(url, header) do
    HTTPoison.get(url, header)
  end
end
