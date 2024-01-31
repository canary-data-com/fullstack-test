defmodule InsiderTradingReportService.IntegrationLogs.IntegrationLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "integration_logs" do
    field :integration_type, :string
    field :endpoint, :string
    field :status, :string
    field :tags, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(integration_log, attrs) do
    integration_log
    |> cast(attrs, [:integration_type, :endpoint, :status, :tags])
    |> validate_required([:integration_type, :endpoint, :status, :tags])
  end

  def insider_transactions_tags, do: "insider_transactions"
end
