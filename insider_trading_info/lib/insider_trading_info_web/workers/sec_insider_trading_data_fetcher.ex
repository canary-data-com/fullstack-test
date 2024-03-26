defmodule InsiderTradingInfoWeb.SECInsiderTradingDataFetcher do
  @moduledoc """
  The SECInsiderTradingDataFetcher is GenServer responsible for sending email for Invinting User
  """
  use GenServer
  require Logger

  alias InsiderTradingInfoWeb.SECInsiderTradeCollectorService

  @previous_year_data_fetch_interval 2 * 60 * 1000
  @recent_data_fetch_interval 24 * 60 * 60 * 1000
  @each_company_recent_data_interval 2 * 60 * 1000

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{fetch_type: :fetch_previous_years_data}, name: __MODULE__)
  end

  def init(state) do
    Logger.info("Starting GenServer of SECInsiderTradingDataFetcher.")
    schedule_task(state)
    {:ok, state}
  end

  defp schedule_task(state) do
    if InsiderTradingInfo.Trading.has_company_with_incomplete_previous_year_data_fetch?() do
      Logger.info(
        "Scheduled  process for fetch previous years data after #{@previous_year_data_fetch_interval} millisecond"
      )

      Process.send_after(self(), :fetch_previous_years_data, @previous_year_data_fetch_interval)
      {:noreply, %{state | fetch_type: :fetch_previous_years_data}}
    else
      Logger.info(
        "Scheduled process for fetch recent data after #{@recent_data_fetch_interval} millisecond"
      )

      Process.send_after(self(), :fetch_recent_data, @recent_data_fetch_interval)
      {:noreply, %{state | fetch_type: :fetch_recent_data}}
    end
  end

  @doc """
  Initiate Process to fetch previous years data
  """
  def handle_info(:fetch_previous_years_data, state) do
    Logger.debug("Executing process to process fetch previous years data.")
    comapny_info = InsiderTradingInfo.Trading.company_for_previous_years_data_fetched()
    Logger.info("Fetching Previous Years Data for #{comapny_info.company_name}")
    SECInsiderTradeCollectorService.retrieve_and_store_insider_trades(comapny_info)
    schedule_task(state)
  end

  def handle_info(:fetch_recent_data, state) do
    Logger.debug("Executing process to process fetch recent data.")

    InsiderTradingInfo.Trading.company_list_for_recent_data_fetched()
    |> Enum.each(fn company_info ->
      Logger.info("Fetching Recent Data for #{company_info.company_name}")
      SECInsiderTradeCollectorService.retrieve_and_store_insider_trades(company_info)
      :timer.sleep(@each_company_recent_data_interval)
    end)

    schedule_task(state)
  end
end
