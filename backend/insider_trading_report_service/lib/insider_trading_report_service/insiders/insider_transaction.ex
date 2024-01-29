defmodule InsiderTradingReportService.Insiders.InsiderTransaction do
  use Ecto.Schema
  import Ecto.Changeset

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
end
