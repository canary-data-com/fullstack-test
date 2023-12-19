defmodule FullstackTest.Services.TradingServiceTest do
  use ExUnit.Case, async: true
  alias FullstackTest.Services.TradingService

  import Mock

  describe "execute_trade/3" do
    test "returns expected response" do
      # Arrange
      selected_company = "AAPL"
      transaction_person = "John Doe"
      shares_amount = "10"
      job_title = "Some Job Title"

      with_mock(File,
        read: fn _ ->
          {:ok,
           """
             {
               "data": [
                  [
                    320193,
                    "Apple Inc.",
                    "AAPL",
                    "Nasdaq"
                  ]
               ]
             }
           """}
        end
      ) do
        # Act
        assert %{} =
                 response =
                 TradingService.execute_trade(
                   selected_company,
                   transaction_person,
                   shares_amount,
                   job_title
                 )

        # Assert
        assert %{
                 job_title: "Some Job Title",
                 market_cap_percentage: market_cap_percentage,
                 person: "John Doe",
                 shares: "10",
                 ticker: "AAPL"
               } = response

        assert market_cap_percentage > 0.0
      end
    end

    test "In case of any errors, market cap is zero" do
      # Arrange
      selected_company = "AAPL"
      transaction_person = "John Doe"
      shares_amount = "10"
      job_title = "Some Job Title"

      with_mock(File,
        read: fn _ ->
          {:error, "Failed to read JSON file"}
        end
      ) do
        # Act
        assert %{} =
                 response =
                 TradingService.execute_trade(
                   selected_company,
                   transaction_person,
                   shares_amount,
                   job_title
                 )

        # Assert
        assert %{
                 job_title: "Some Job Title",
                 market_cap_percentage: 0.0,
                 person: "John Doe",
                 shares: "10",
                 ticker: "AAPL"
               } = response
      end
    end
  end

  describe "get_companies_tickers/0" do
    test "returns expected response" do
      # Arrange
      with_mock(File,
        read: fn _ ->
          {:ok,
           """
             {
               "data": [
                  [
                    320193,
                    "Apple Inc.",
                    "AAPL",
                    "Nasdaq"
                  ]
               ]
             }
           """}
        end
      ) do
        # Act
        assert ["AAPL"] = TradingService.get_companies_tickers()
      end
    end

    test "In case of any errors, returns empty list" do
      # Arrange
      with_mock(File,
        read: fn _ ->
          {:error, "Failed to read JSON file"}
        end
      ) do
        # Act
        assert [] = TradingService.get_companies_tickers()
      end
    end
  end
end
