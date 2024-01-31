defmodule InsiderTradingReportService.Repo.Migrations.CreateIntegrationLogs do
  use Ecto.Migration

  def change do
    create table(:integration_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :integration_type, :string, null: false
      add :endpoint, :string, null: false
      add :status, :string, null: false
      add :tags, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
