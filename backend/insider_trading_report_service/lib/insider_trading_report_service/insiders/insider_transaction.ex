defmodule InsiderTradingReportService.Insiders.InsiderTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias InsiderTradingReportService.Insiders.InsiderTransaction

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "insider_transactions" do
    field :name, :string
    field :ticker, :string
    field :job_title, :string
    field :startDate, :date
    field :shares, :float
    field :amount, :decimal
    field :market_cap, :decimal
    field :market_cap_percentage, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(insider_transaction, attrs) do
    insider_transaction
    |> cast(attrs, [
      :ticker,
      :name,
      :job_title,
      :startDate,
      :shares,
      :amount,
      :market_cap,
      :market_cap_percentage
    ])
    |> validate_required([:ticker, :name, :job_title, :startDate, :shares])
  end

  def transform(%InsiderTransaction{} = insider_transaction, map) do
    {shares, _} = Float.parse(to_string(map.shares))
    {:ok, startDate} = Date.from_iso8601(map.startDate)
    map = %{map | shares: shares, startDate: startDate}

    struct(insider_transaction, map)
    |> calculate_market_cap_percentage
  end

  def calculate_market_cap_percentage(
        %InsiderTransaction{amount: amount, market_cap: market_cap} = it
      )
      when is_nil(amount) or is_nil(market_cap) do
    %{it | market_cap_percentage: nil}
  end

  def calculate_market_cap_percentage(
        %InsiderTransaction{amount: amount, market_cap: market_cap} = it
      ) do
    result = amount / market_cap * 100
    result = Float.ceil(result, 4)
    %{it | market_cap_percentage: result}
  end

  def set_timestamps(%InsiderTransaction{} = insider_transaction) do
    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    %{insider_transaction | inserted_at: timestamp, updated_at: timestamp}
  end

  def to_map(insider_transaction, keep_id \\ false)

  def to_map(%InsiderTransaction{} = insider_transaction, keep_id) when keep_id do
    insider_transaction
    |> Map.from_struct()
    |> Map.delete(:__meta__)
  end

  def to_map(%InsiderTransaction{} = insider_transaction, keep_id) when not keep_id do
    insider_transaction
    |> to_map(true)
    |> Map.delete(:id)
  end
end
