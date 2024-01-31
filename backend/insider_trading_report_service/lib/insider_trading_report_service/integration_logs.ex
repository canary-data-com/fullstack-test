defmodule InsiderTradingReportService.IntegrationLogs do
  @moduledoc """
  The IntegrationLogs context.
  """

  import Ecto.Query, warn: false
  alias InsiderTradingReportService.Repo

  alias InsiderTradingReportService.IntegrationLogs.IntegrationLog

  def list_integration_logs do
    Repo.all(IntegrationLog)
  end

  def last_log_by_tags(tags) do
    IntegrationLog
    |> where([l], l.tags == ^tags)
    |> last(:inserted_at)
    |> Repo.one()
  end

  def get_integration_log!(id), do: Repo.get!(IntegrationLog, id)

  def create_integration_log(attrs \\ %{}) do
    %IntegrationLog{}
    |> IntegrationLog.changeset(attrs)
    |> Repo.insert()
  end

  def update_integration_log(%IntegrationLog{} = integration_log, attrs) do
    integration_log
    |> IntegrationLog.changeset(attrs)
    |> Repo.update()
  end

  def delete_integration_log(%IntegrationLog{} = integration_log) do
    Repo.delete(integration_log)
  end

  def change_integration_log(%IntegrationLog{} = integration_log, attrs \\ %{}) do
    IntegrationLog.changeset(integration_log, attrs)
  end
end
