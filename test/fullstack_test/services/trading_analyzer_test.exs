defmodule FullstackTest.Services.TradingAnalayerTest do
  use ExUnit.Case, async: true
  alias FullstackTest.Services.TradingAnalyzer

  @tickers_response %{
    "data" => [
      [
        320_193,
        "Apple Inc.",
        "AAPL",
        "Nasdaq"
      ]
    ]
  }

  import Mock

  describe "execute_trade/3" do
    test "returns expected response" do
      assert %{} =
               response = TradingAnalyzer.analyze_trading("AAPL")

      # Assert
      assert %{
               job_title: "Office of Technology",
               market_cap_percentage: market_cap_percentage,
               person: "Apple Inc.",
               shares: 15_552_799_744,
               company_ticker: "Apple Inc. - 320193"
             } = response

      assert market_cap_percentage > 0.0
    end

    test "when ticker does not exist return error" do
      assert {:error, "Failed to fetch trading data"} =
               TradingAnalyzer.analyze_trading("something")
    end
  end

  describe "get_companies_tickers/0" do
    test "returns expected response" do
      # Arrange
      with_mock(Req,
        get: fn _, _ ->
          {:ok,
           %Req.Response{
             status: 200,
             body: @tickers_response
           }}
        end
      ) do
        # Act
        assert {:ok, %{"AAPL" => 320_193}} = TradingAnalyzer.fetch_company_tickers()
      end
    end
  end
end
