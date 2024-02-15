defmodule Trading.InsiderTradings do
  @moduledoc """
    This module contain functions to Fetch insider tradings.
  """

  @ticker_url "https://www.sec.gov/files/company_tickers_exchange.json"
  @edgar_url_template "https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=%s&owner=&count=100&output=atom"
  @yahoo_finance_url_template "https://finance.yahoo.com/quote/%s?p=%s"

  @headers [{"User-Agent", "trading/0.1.0"}, {"Accept", "*/*"}]

  @http_client Application.compile_env(:trading, :insider_api, Trading.InsiderTradingClient)

  @doc """
    List insider trading based on form 3, 4 and 5 for given or random company.

    ## Examples

      iex> list_insider_tradings("MICROSOFT CORP")
       [%{
          form_type: "4",
          job_title: "",
          market_cap: "3.01T",
          person: "",
          shares: "",
          company: "MICROSOFT CORP",
          filing_date: "2022-09-23",
          filing_href: "https://www.sec.gov/Archives/edgar/data/849145/000120919122051196/0001209191-22-051196-index.htm",
          form_name: "Statement of changes in beneficial ownership of securities",
          accession_number: "0001209191-22-051196",
          amend: ""
          }]
  """
  def list_insider_tradings(company_name) when company_name in ["", nil] do
    fetch_tickers()
    |> Enum.random()
    |> process_company()
    |> List.flatten()
  end

  def list_insider_tradings(company_name) do
    case fetch_tickers() do
      result when is_list(result) ->
        result
        |> Enum.filter(fn [_, name, _, _] ->
          String.downcase(company_name) == String.downcase(name)
        end)
        |> Enum.map(&process_company(&1))
        |> List.flatten()

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp fetch_tickers() do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           @http_client.http_get(@ticker_url, @headers),
         {:ok, json} <- Jason.decode(body) do
      json["data"]
    else
      {:ok, %HTTPoison.Response{status_code: code, body: _body}} ->
        {:error, "Failed to fetch tickers. Reason: #{code} Error"}

      {:error, reason} ->
        {:error, "Failed to fetch JSON. Reason: #{inspect(reason)}"}
    end
  end

  defp process_company([cik, company, ticker, _exchange]) do
    market_cap = fetch_market_cap(ticker)

    cik
    |> fetch_insider_data()
    |> Enum.map(&parse_insider_form(&1, company, market_cap))
  end

  defp fetch_insider_data(cik) do
    url = String.replace(@edgar_url_template, "%s", to_string(cik))

    with {:ok, %HTTPoison.Response{body: body}} <-
           @http_client.http_get(url, @headers),
         {:ok, parsed_xml} <- Floki.parse_document(body) do
      parsed_xml
      |> Floki.find("entry")
      |> Enum.filter(&is_insider_form?(&1))
    else
      _ ->
        {:error, "Failed to fetch insider data."}
    end
  end

  defp is_insider_form?(form) do
    form_type = Floki.find(form, "category[term]") |> Floki.attribute("term") |> Floki.text()
    Enum.member?(["3", "4", "5"], form_type)
  end

  defp parse_insider_form(form, company, market_cap) do
    # not able to find -- number of shares, name, job title in response of @edgar_url_template api.
    %{
      company: company,
      form_type: Floki.find(form, "category[term]") |> Floki.attribute("term") |> Floki.text(),
      market_cap: market_cap,
      filing_date: Floki.find(form, "content > filing-date") |> Floki.text(),
      accession_number: Floki.find(form, "content > accession-number") |> Floki.text(),
      amend: Floki.find(form, "content > amend") |> Floki.text(),
      form_name: Floki.find(form, "content > form-name") |> Floki.text(),
      filing_href: Floki.find(form, "content > filing-href") |> Floki.text(),
      person: Floki.find(form, "content > name") |> Floki.text(),
      job_title: Floki.find(form, "content > email") |> Floki.text(),
      shares: Floki.find(form, "content > shares") |> Floki.text()
    }
  end

  defp fetch_market_cap(ticker) do
    url = String.replace(@yahoo_finance_url_template, "%s", ticker)

    with {:ok, %HTTPoison.Response{body: body}} <- @http_client.http_get(url, @headers),
         {:ok, parsed_html} <- Floki.parse_document(body) do
      parsed_html
      |> Floki.find("td[data-test='MARKET_CAP-value']")
      |> Floki.text()
    else
      _ ->
        {:error, "Failed to fetch market cap."}
    end
  end
end
