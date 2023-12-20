defmodule FullstackTestWeb.TradingController do
  alias FullstackTest.Services.TradingAnalyzer
  use FullstackTestWeb, :controller

  def index(conn, _) do
    {:ok, response} = TradingAnalyzer.fetch_company_tickers()

    conn
    |> put_status(:ok)
    |> put_resp_content_type("application/json")
    |> json(response)
  end

  def submit(conn, %{"selectedCompany" => selected_company}) do
    response =
      TradingAnalyzer.analyze_trading(selected_company)

    conn
    |> put_status(:ok)
    |> put_resp_content_type("application/json")
    |> json(response)
  end
end
