defmodule TradingWeb.InsiderTradingController do
  use TradingWeb, :controller

  alias Trading.InsiderTradings

  def index(conn, params) do
    case InsiderTradings.list_insider_tradings(params["company_name"]) do
      result when is_list(result) ->
        json(conn, %{data: result})

      {:error, reason} ->
        conn
        |> json(%{error: reason})
        |> halt()

      _ ->
        conn
        |> json(%{error: "Something went wrong!"})
    end
  end
end
