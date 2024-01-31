defmodule InsiderTradingReportService.Insiders do
  @moduledoc """
  The Insiders context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias InsiderTradingReportService.IntegrationLogs
  alias InsiderTradingReportService.Tradings
  alias InsiderTradingReportService.Repo
  alias InsiderTradingReportService.Insiders.InsiderTransaction
  alias InsiderTradingReportService.IntegrationLogs.IntegrationLog

  def list_insider_transactions do
    Repo.all(InsiderTransaction)
  end

  def list_insider_transactions_by_ticker(ticker, cached \\ false)

  def list_insider_transactions_by_ticker(ticker, cached) when not cached do
    verify_last_update(ticker)
  end

  def list_insider_transactions_by_ticker(ticker, cached) when cached do
    Logger.info("Fetching cached data!")

    result =
      InsiderTransaction
      |> where([t], t.ticker == ^ticker)
      |> Repo.all()

    {:ok, result}
  end

  def refresh_insider_transactions(ticker) do
    Logger.info("refresing transactions!")

    case Tradings.insider_transactions(ticker) do
      {:ok, result} ->
        result
        |> create_many_insider_transactions

        list_insider_transactions_by_ticker(ticker, true)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_insider_transaction!(id), do: Repo.get!(InsiderTransaction, id)

  def create_insider_transaction(attrs \\ %{}) do
    %InsiderTransaction{}
    |> InsiderTransaction.changeset(attrs)
    |> Repo.insert()
  end

  def create_many_insider_transactions(entries) do
    entries =
      entries
      |> Enum.map(&InsiderTransaction.transform(%InsiderTransaction{}, &1))
      |> Enum.map(&InsiderTransaction.set_timestamps/1)
      |> Enum.map(&InsiderTransaction.to_map/1)

    InsiderTransaction
    |> Repo.insert_all(entries,
      on_conflict: :nothing,
      conflict_target: [:startDate, :ticker, :name]
    )
  end

  def update_insider_transaction(%InsiderTransaction{} = insider_transaction, attrs) do
    insider_transaction
    |> InsiderTransaction.changeset(attrs)
    |> Repo.update()
  end

  def delete_insider_transaction(%InsiderTransaction{} = insider_transaction) do
    Repo.delete(insider_transaction)
  end

  def change_insider_transaction(%InsiderTransaction{} = insider_transaction, attrs \\ %{}) do
    InsiderTransaction.changeset(insider_transaction, attrs)
  end

  defp verify_last_update(ticker) do
    # last_update_day = DateTime.to_date(last_transaction.updated_at)
    today = Date.utc_today()

    last_update_day =
      case IntegrationLogs.last_log_by_tags(IntegrationLog.insider_transactions_tags(ticker)) do
        nil -> Date.add(today, -1)
        last_log -> DateTime.to_date(last_log.inserted_at)
      end

    case Date.compare(last_update_day, today) do
      :eq ->
        list_insider_transactions_by_ticker(ticker, true)

      _ ->
        refresh_insider_transactions(ticker)
    end
  end
end
