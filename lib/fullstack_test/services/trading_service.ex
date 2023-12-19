defmodule FullstackTest.Services.TradingService do
  @moduledoc """
  This module is responsible for executing trades.
  """

  @doc """
  Executes a trade.

  ## Examples

      iex> FullstackTest.Services.TradingService.execute_trade("AAPL", "John Doe", 10)
      {:ok,
       %{
         date: "2021-10-20T15:45:00.000000Z",
          job_title: "Some Job Title",
          market_cap_percentage: 0.000000000
          person: "John Doe",
          shares: 10,
          ticker: "AAPL"
        }
  """
  def execute_trade(selected_company, transaction_person, shares_amount, job_title) do
    # Calculate market cap percentage
    market_cap_percentage = calculate_market_cap_percentage(selected_company, shares_amount)

    # Construct the response
    %{
      ticker: selected_company,
      person: transaction_person,
      job_title: job_title,
      date: DateTime.utc_now() |> NaiveDateTime.truncate(:second),
      shares: shares_amount,
      market_cap_percentage: market_cap_percentage
    }
  end

  @doc """
  Fetches the list of companies and their tickers.

  ## Examples

      iex> FullstackTest.Services.TradingService.get_companies_tickers()
      ["AAPL", "GOOGL", "TESLA"]
  """
  def get_companies_tickers do
    # Fetch the company data
    case fetch_company_data() do
      {:ok, %{"data" => company_data}} ->
        # Extract the company tickers
        Enum.map(company_data, fn [_cik, _name, ticker, _exchange] -> ticker end)

      {:error, _} ->
        # Handle error when fetching company data
        []
    end
  end

  defp calculate_market_cap_percentage(selected_company, shares_amount) do
    # Get the stock price and total market cap for the selected company
    {stock_price, total_market_cap} = get_stock_info(selected_company)

    # Calculate the market cap percentage
    market_cap_percentage =
      if stock_price > 0.0 do
        String.to_integer(shares_amount) * stock_price / total_market_cap * 100
      else
        0.0
      end

    market_cap_percentage
  end

  defp fetch_company_data() do
    # read json file
    with {:ok, json} <- File.read("priv/companies.json"),
         # Parse the JSON data
         {:ok, data} <- Jason.decode(json) do
      {:ok, data}
    else
      {:error, _} ->
        {:error, "Failed to read JSON file"}
    end
  end

  defp get_stock_info(selected_company) do
    with {:ok, %{"data" => company_data}} <-
           fetch_company_data(),
         {:ok, [_cik, _name, _ticker, exchange]} <-
           find_company_info(selected_company, company_data),
         {stock_price, total_market_cap} <-
           fetch_stock_price_and_market_cap(exchange) do
      {stock_price, total_market_cap}
    else
      _ ->
        # Handle error when fetching company data
        {0.0, 0.0}
    end
  end

  defp find_company_info(selected_company, company_data) do
    case Enum.find(company_data, fn x ->
           [_cik, _name, ticker, _exchange] = x
           ticker == selected_company
         end) do
      [cik, name, ticker, exchange] when exchange != nil ->
        {:ok, [cik, name, ticker, exchange]}

      nil ->
        {:error, "Company info not found"}
    end
  end

  # Simulate stock price and market cap data for testing
  defp fetch_stock_price_and_market_cap(_exchange) do
    # Generate random or fictional stock price and market cap values
    {Enum.random(50..500), Enum.random(1_000_000..10_000_000)}
  end
end
