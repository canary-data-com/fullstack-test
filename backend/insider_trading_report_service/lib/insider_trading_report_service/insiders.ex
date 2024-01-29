defmodule InsiderTradingReportService.Insiders do
  @moduledoc """
  The Insiders context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias InsiderTradingReportService.Tradings
  alias InsiderTradingReportService.Repo
  alias InsiderTradingReportService.Insiders.InsiderTransaction

  @doc """
  Returns the list of insider_transactions.

  ## Examples

      iex> list_insider_transactions()
      [%InsiderTransaction{}, ...]

  """
  def list_insider_transactions do
    Repo.all(InsiderTransaction)
  end

  def list_insider_transactions_by_ticker(ticker, cached \\ false)

  def list_insider_transactions_by_ticker(ticker, cached) when not cached do
    last_updated =
      InsiderTransaction
      |> last(:updated_at)
      |> Repo.one()

    case last_updated do
      nil ->
        Tradings.insider_transactions(ticker)
        |> prepare_to_insert
        |> create_many_insider_transactions

        list_insider_transactions_by_ticker(ticker, true)

      %InsiderTransaction{updated_at: updated_at} ->
        last_update_day = DateTime.to_date(updated_at)
        today = Date.utc_today()

        case Date.compare(last_update_day, today) do
          :eq ->
            list_insider_transactions_by_ticker(ticker, true)

          _ ->
            Tradings.insider_transactions(ticker)
            |> prepare_to_insert
            |> create_many_insider_transactions

            list_insider_transactions_by_ticker(ticker, true)
        end
    end
  end

  def list_insider_transactions_by_ticker(ticker, cached) when cached do
    Logger.info("Fetching cached data!")

    InsiderTransaction
    |> where([t], t.ticker == ^ticker)
    |> Repo.all()
  end

  @doc """
  Gets a single insider_transaction.

  Raises `Ecto.NoResultsError` if the Insider transaction does not exist.

  ## Examples

      iex> get_insider_transaction!(123)
      %InsiderTransaction{}

      iex> get_insider_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_insider_transaction!(id), do: Repo.get!(InsiderTransaction, id)

  @doc """
  Creates a insider_transaction.

  ## Examples

      iex> create_insider_transaction(%{field: value})
      {:ok, %InsiderTransaction{}}

      iex> create_insider_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_insider_transaction(attrs \\ %{}) do
    %InsiderTransaction{}
    |> InsiderTransaction.changeset(attrs)
    |> Repo.insert()
  end

  def create_many_insider_transactions(entries) do
    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    placeholders = %{timestamp: timestamp}

    entries =
      entries
      |> Enum.map(fn entry ->
        entry
        |> Map.put(
          :inserted_at,
          {:placeholder, :timestamp}
        )
        |> Map.put(
          :updated_at,
          {:placeholder, :timestamp}
        )
      end)

    InsiderTransaction
    |> Repo.insert_all(entries,
      placeholders: placeholders,
      on_conflict: :nothing,
      conflict_target: [:startDate, :ticker, :name]
    )
  end

  @doc """
  Updates a insider_transaction.

  ## Examples

      iex> update_insider_transaction(insider_transaction, %{field: new_value})
      {:ok, %InsiderTransaction{}}

      iex> update_insider_transaction(insider_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_insider_transaction(%InsiderTransaction{} = insider_transaction, attrs) do
    insider_transaction
    |> InsiderTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a insider_transaction.

  ## Examples

      iex> delete_insider_transaction(insider_transaction)
      {:ok, %InsiderTransaction{}}

      iex> delete_insider_transaction(insider_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_insider_transaction(%InsiderTransaction{} = insider_transaction) do
    Repo.delete(insider_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking insider_transaction changes.

  ## Examples

      iex> change_insider_transaction(insider_transaction)
      %Ecto.Changeset{data: %InsiderTransaction{}}

  """
  def change_insider_transaction(%InsiderTransaction{} = insider_transaction, attrs \\ %{}) do
    InsiderTransaction.changeset(insider_transaction, attrs)
  end

  defp prepare_to_insert(data) do
    data
    |> Enum.map(fn tr ->
      {shares, _} = Float.parse(to_string(tr.shares))
      {:ok, startDate} = Date.from_iso8601(tr.startDate)
      %{tr | shares: shares, startDate: startDate}
    end)
    |> Enum.map(fn tr ->
      Map.put(
        tr,
        :market_cap_percentage,
        calculate_market_cap_percentage(tr.amount, tr.market_cap)
      )
    end)
  end

  defp calculate_market_cap_percentage(amount, market_cap)
       when is_nil(amount) or is_nil(market_cap) do
    nil
  end

  defp calculate_market_cap_percentage(amount, market_cap) do
    result = amount / market_cap * 100
    Float.ceil(result, 4)
  end
end
