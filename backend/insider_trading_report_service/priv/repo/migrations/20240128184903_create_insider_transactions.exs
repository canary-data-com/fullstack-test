defmodule InsiderTradingReportService.Repo.Migrations.CreateInsiderTransactions do
  use Ecto.Migration

  def change do
    create table(:insider_transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ticker, :string, null: false
      add :name, :string
      add :job_title, :string
      add :startDate, :date
      add :shares, :float
      add :amount, :decimal
      add :market_cap, :decimal
      add :market_cap_percentage, :float

      timestamps(type: :utc_datetime)
    end

    create unique_index(:insider_transactions, [:ticker, :name, :startDate])
  end
end
