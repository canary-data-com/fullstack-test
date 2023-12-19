defmodule FullstackTestWeb.TradingController do
  alias FullstackTest.Services.TradingService
  use FullstackTestWeb, :controller

  def index(conn, _) do
    response = TradingService.get_companies_tickers()

    conn
    |> put_status(:ok)
    |> put_resp_content_type("application/json")
    |> json(response)
  end

  def submit(conn, %{
        "selectedCompany" => selected_company,
        "transactionPerson" => transaction_person,
        "sharesAmount" => shares_amount,
        "jobTitle" => job_title
      }) do
    response =
      TradingService.execute_trade(selected_company, transaction_person, shares_amount, job_title)

    conn
    |> put_status(:ok)
    |> put_resp_content_type("application/json")
    |> json(response)
  end
end
