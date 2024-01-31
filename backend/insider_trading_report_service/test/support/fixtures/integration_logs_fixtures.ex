defmodule InsiderTradingReportService.IntegrationLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InsiderTradingReportService.IntegrationLogs` context.
  """

  @doc """
  Generate a integration_log.
  """
  def integration_log_fixture(attrs \\ %{}) do
    {:ok, integration_log} =
      attrs
      |> Enum.into(%{
        endpoint: "some endpoint",
        integration_type: "some integration_type",
        status: "200",
        tags: "teste"
      })
      |> InsiderTradingReportService.IntegrationLogs.create_integration_log()

    integration_log
  end
end
