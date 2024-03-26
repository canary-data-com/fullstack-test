defmodule InsiderTradingInfoWeb.SECInsiderTradeCollectorService do
  @moduledoc """
  This module is responsible for collecting, parsing, and storing insider trade information
  from SEC.gov and the EDGAR search system.

  ## Responsibilities

  - Fetch insider trade data from SEC.gov and the EDGAR search system.
  - Parse the fetched data to extract relevant insider trade information.
  - Store the parsed insider trade information in the database.
  """

  require Logger
  alias InsiderTradingInfo.Trading

  @doc """
  Retrieve and Store Insider Trades Info for Previous Years Data Fetch
  """
  def retrieve_and_store_insider_trades(
        %InsiderTradingInfo.CompanyInfo{
          data_availability_date: data_availability_date,
          previous_years_data_fetched: false,
          insider_trades: trades
        } = company_info
      ) do
    before_date =
      if(trades == [], do: Date.utc_today(), else: hd(trades).filling_date)
      |> Date.to_iso8601()
      |> String.replace("-", "")

    after_date = Date.to_iso8601(data_availability_date) |> String.replace("-", "")

    fetch_transform_and_persist(company_info, after_date, before_date)
  end


  def retrieve_and_store_insider_trades(
        %InsiderTradingInfo.CompanyInfo{
          previous_years_data_fetched: true,
          insider_trades: trades
        } = company_info
      ) do
    before_date =
      Date.utc_today()
      |> Date.to_iso8601()
      |> String.replace("-", "")

    after_date =
      if(trades == [], do: Date.utc_today(), else: List.last(trades).filling_date)
      |> Date.add(1)
      |> Date.to_iso8601()
      |> String.replace("-", "")

    fetch_transform_and_persist(company_info, after_date, before_date)
  end

  @doc """
  Fetch from SEC.gov and parse,transform and persist.
  """
  def fetch_transform_and_persist(
        %InsiderTradingInfo.CompanyInfo{
          cik: cik,
          company_name: company
        } = company_info,
        after_date,
        before_date,
        count \\ 100,
        start \\ 0
      ) do
    Logger.info(
      "Fetching Insider Trades Info from SEC EDGAR for CIK #{cik} and Date range from #{after_date} and #{before_date}"
    )

    with {:ok, url} <- get_edgar_search_url(cik, before_date, after_date, count, start),
         {:ok, trade_entries, entry_count} <- fetch_xml_entries(url) do
      Enum.map(trade_entries, fn entry -> parse_insider_form(entry, company) end)
      |> List.flatten()
      |> save_to_db(company_info, entry_count)
    else
      error ->
        Logger.error(
          "Failed to process insider data from SEC EDGAR for CIK #{cik} and date range #{after_date} and #{before_date}. Reason: #{inspect(error)}"
        )

        {:error, "Failed to process insider data."}
    end
  end

  @doc """
  Store insider trade info into the database and update previous year data fetched status
  """
  def save_to_db(transaction_list, company_info, entry_count) do
    Logger.debug(
      "Storing insider trade info to the db for company name: #{company_info.company_name} and number of records: #{length(transaction_list)}"
    )

    Enum.each(transaction_list, fn insider_trade_info ->
      updated_map = Map.put(insider_trade_info, :company_info_id, company_info.id)

      InsiderTradingInfo.Repo.insert!(
        InsiderTradingInfo.InsiderTrade.changeset(%InsiderTradingInfo.InsiderTrade{}, updated_map)
      )
    end)

    if has_previous_year_data_fetched?(
         company_info.data_availability_date,
         transaction_list,
         entry_count
       ) do
      Logger.info(
        "Updating company info for previous_years_data_fetched status for company name: #{company_info.company_name}"
      )

      Trading.update_company_info(company_info, %{previous_years_data_fetched: true})
    end

    {:success, transaction_list}
  end


  defp get_edgar_search_url(cik, date_before, date_after, count, start) do
    url =
      Application.get_env(:insider_trading_info, :edgar_url_template)
      |> String.replace("%k", to_string(cik))
      |> String.replace("%b", date_before)
      |> String.replace("%a", date_after)
      |> String.replace("%s", to_string(start))
      |> String.replace("%c", to_string(count))

    Logger.debug("URL for fetcing insider trades: #{url}")

    {:ok, url}
  end


  defp fetch_xml_entries(url) do
    headers = Application.get_env(:insider_trading_info, :headers)

    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.get(url, headers),
         {:ok, parsed_xml} <- Floki.parse_document(body) do
      list =
        parsed_xml
        |> Floki.find("entry")
        |> Enum.filter(&is_insider_form?(&1))

      {:ok, list, Floki.find(parsed_xml, "entry") |> Enum.count()}
    else
      error ->
        Logger.error("Failed to fetch entries form from SEC EDGAR. Reason: #{inspect(error)}")
        {:error, "Failed to fetch entries form from SEC EDGAR."}
    end
  end


  defp is_insider_form?(form) do
    form_type = Floki.find(form, "category[term]") |> Floki.attribute("term") |> Floki.text()
    Enum.member?(["4", "5"], form_type)
  end


  defp parse_insider_form(form, company) do
    insider_transactions =
      Floki.find(form, "content > filing-href")
      |> Floki.text()
      |> String.replace("-index.htm", ".txt")
      |> get_transaction_details()

    Enum.map(insider_transactions, fn transaction ->
      {transaction_share, _} = Integer.parse(transaction.transaction_share)

      %{
        company: company,
        filling_date: Floki.find(form, "content > filing-date") |> Floki.text(),
        accession_number: Floki.find(form, "content > accession-number") |> Floki.text(),
        share_qty: transaction_share,
        transaction_code: transaction.transaction_code,
        transaction_price: transaction.transaction_price,
        job_title: transaction.job_title,
        person_name: transaction.owner_name,
        filling_url: transaction.url,
        transaction_date: transaction.transaction_date
      }
    end)
  end


  defp set_job_title(map, parsed_xml) do
    title_director = "Director"
    title_10_per_owner = "10% Owner"

    is_director = parsed_xml |> Floki.find("isdirector") |> Floki.text()

    job_title =
      case is_director do
        "1" ->
          title_director

        _ ->
          is_officer = parsed_xml |> Floki.find("isofficer") |> Floki.text()

          case is_officer do
            "1" -> parsed_xml |> Floki.find("officertitle") |> Floki.text()
            _ -> title_10_per_owner
          end
      end

    Map.put(map, :job_title, job_title)
  end


  defp set_owner_name(map, parsed_xml) do
    owner_name =
      parsed_xml
      |> Floki.find("rptownername")
      |> Floki.text()

    Map.put(map, :owner_name, owner_name)
  end

  defp set_non_derivative_transactions(map, parsed_xml) do
    parsed_xml
    |> Floki.find("nonderivativetransaction")
    |> Enum.map(fn transaction ->
      %{
        job_title: map.job_title,
        owner_name: map.owner_name,
        transaction_code: transaction |> Floki.find("transactioncode") |> Floki.text(),
        transaction_price:
          transaction |> Floki.find("transactionpricepershare > value") |> Floki.text(),
        transaction_share: transaction |> Floki.find("transactionshares > value") |> Floki.text(),
        transaction_date: transaction |> Floki.find("transactiondate > value") |> Floki.text(),
        url: map.url
      }
    end)
  end

  @doc """
  Get Insider Trade Transaction List
  """
  def get_transaction_details(url) do
    headers = Application.get_env(:insider_trading_info, :headers)

    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.get(url, headers),
         {:ok, parsed_xml} <- Floki.parse_document(body) do
      %{url: url}
      |> set_job_title(parsed_xml)
      |> set_owner_name(parsed_xml)
      |> set_non_derivative_transactions(parsed_xml)
    else
      error ->
        Logger.error("Failed to fetch filling form from SEC EDGAR. Reason: #{inspect(error)}")
        {:error, "Failed to fetch insider data."}
    end
  end


  defp has_previous_year_data_fetched?(_data_availability_date, [], _entry_count), do: false

  defp has_previous_year_data_fetched?(data_availability_date, list, entry_count),
    do: List.last(list).filling_date <= data_availability_date || entry_count < 100
end
