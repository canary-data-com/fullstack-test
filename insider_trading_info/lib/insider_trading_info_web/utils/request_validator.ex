defmodule InsiderTradingInfoWeb.RequestValidator do
  @moduledoc """
  This module is responsible to validate incoming request
  """

  def validate_insider_trade_req(params) do
    schema = %{
      "ticker" => [:string, &validate_ticker/1, :required]
    }

    Skooma.valid?(params, schema)
  end

  def validate_ticker(data) do
    if String.length(data) == 4 do
      :ok
    else
      {:error, "Invalid Ticker"}
    end
  end
end
