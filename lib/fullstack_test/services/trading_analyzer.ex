defmodule FullstackTest.Services.TradingAnalyzer do
  @sec_ticker_url "https://www.sec.gov/files/company_tickers_exchange.json"
  @yahoo_finance_url "https://query2.finance.yahoo.com/v7/finance/options/"
  # Modify the user agent to avoid 403 error
  @user_agent "Mozila/5.0"

  # Fetches the company tickers from SEC website
  def fetch_company_tickers() do
    with {:ok, %Req.Response{status: 200, body: body}} <-
           Req.get(@sec_ticker_url, user_agent: @user_agent),
         %{"data" => data} <- body do
      tickers =
        Enum.reduce(data, %{}, fn [cik, _, ticker, _], acc ->
          Map.put(acc, ticker, cik)
        end)

      {:ok, tickers}
    else
      _ -> {:error, "Failed to fetch company tickers"}
    end
  end

  def analyze_trading(selected_company) do
    with {:ok, tickers} <- fetch_company_tickers(),
         {:ok, trading_data} <- fetch_trading_data(selected_company, tickers),
         {:ok, market_cap} <-
           fetch_market_cap(selected_company),
         report <-
           analyze_insider_trading(
             trading_data,
             market_cap,
             Map.get(tickers, selected_company, "")
           ) do
      report
    else
      {:error, reason} -> {:error, reason}
    end
  end

  # Fetches the trading data from EDGAR website
  defp fetch_trading_data(selected_company, tickers) do
    with selected_ticker when is_integer(selected_ticker) <- Map.get(tickers, selected_company),
         {:ok, %Req.Response{status: 200, body: body}} <-
           Req.get(
             "https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{selected_ticker}&owner=include&count=100&output=atom",
             user_agent: @user_agent
           ),
         trading_data <- parse_trading_data(body) do
      {:ok, trading_data}
    else
      _ -> {:error, "Failed to fetch trading data"}
    end
  end

  # Fetches the market cap from Yahoo Finance website
  defp fetch_market_cap(selected_company) do
    with {:ok, %Req.Response{status: 200, body: body}} <-
           Req.get("#{@yahoo_finance_url}#{selected_company}", user_agent: @user_agent),
         market_cap <- parse_market_cap(body) do
      {:ok, market_cap}
    else
      _ -> {:error, "Failed to fetch market cap"}
    end
  end

  # Analyzes the insider trading data
  defp analyze_insider_trading(trading_data, market_cap, ticker) do
    [decimal, rest] =
      market_cap["market_cap_percentage"]
      |> Float.to_string()
      |> String.split(".")

    {rest, _} =
      rest
      |> String.split_at(2)

    market_cap_percentage = "#{decimal}.#{rest}"

    today = DateTime.utc_now()
    date = "#{today.month}/#{today.day}/#{today.year} #{today.hour}:#{today.minute}"

    %{
      job_title: trading_data["office"],
      person: trading_data["conformed-name"],
      shares: market_cap["shares_outstanding"],
      company_ticker: "#{trading_data["conformed-name"]} - #{ticker}",
      market_cap_percentage: market_cap_percentage,
      date: date
    }
  end

  # Parses the trading data
  defp parse_trading_data(body) do
    # logic for EDGAR XML data and return the trading data
    # parse to json
    body
    |> XmlToMap.naive_map()
    |> extract_trading_data()
  end

  # Parses the market cap
  def parse_market_cap(%{"optionChain" => %{"result" => [result]}}) do
    quote = Map.get(result, "quote", %{})
    market_cap = Map.get(quote, "marketCap", 0)

    options = Map.get(result, "options", [])
    total_market_cap_percentage = calculate_total_market_cap_percentage(options, market_cap)

    %{
      "market_cap" => market_cap,
      "market_cap_percentage" => total_market_cap_percentage,
      "shares_outstanding" => Map.get(quote, "sharesOutstanding", 0)
    }
  end

  defp calculate_total_market_cap_percentage(options, total_market_cap) do
    total_last_price =
      Enum.reduce(options, 0, fn option, acc ->
        calls = Map.get(option, "calls", [])
        puts = Map.get(option, "puts", [])

        total_option_price =
          Enum.reduce(calls ++ puts, 0, fn sub_option, sub_acc ->
            last_price = Map.get(sub_option, "lastPrice", 0)
            sub_acc + last_price
          end)

        acc + total_option_price
      end)

    total_market_cap_percentage = total_last_price / total_market_cap * 100
    total_market_cap_percentage
  end

  def extract_trading_data(json) do
    feed = Map.get(json, "feed", %{})
    company_info = Map.get(feed, "company-info", %{})

    trading_data = %{
      "conformed-name" => Map.get(company_info, "conformed-name", ""),
      "cik" => Map.get(company_info, "cik", ""),
      "assigned-sic-desc" => Map.get(company_info, "assigned-sic-desc", ""),
      "fiscal-year-end" => Map.get(company_info, "fiscal-year-end", ""),
      "office" => Map.get(company_info, "office", ""),
      "state-of-incorporation" => Map.get(company_info, "state-of-incorporation", "")
    }

    trading_data
  end
end
