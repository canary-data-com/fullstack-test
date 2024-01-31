defmodule InsiderTradingReportService.IntegrationLogsTest do
  use InsiderTradingReportService.DataCase

  alias InsiderTradingReportService.IntegrationLogs

  describe "integration_logs" do
    alias InsiderTradingReportService.IntegrationLogs.IntegrationLog

    import InsiderTradingReportService.IntegrationLogsFixtures

    @invalid_attrs %{integration_type: nil, endpoint: nil}

    test "list_integration_logs/0 returns all integration_logs" do
      integration_log = integration_log_fixture()
      assert IntegrationLogs.list_integration_logs() == [integration_log]
    end

    test "get_integration_log!/1 returns the integration_log with given id" do
      integration_log = integration_log_fixture()
      assert IntegrationLogs.get_integration_log!(integration_log.id) == integration_log
    end

    test "create_integration_log/1 with valid data creates a integration_log" do
      valid_attrs = %{
        integration_type: "some integration_type",
        endpoint: "some endpoint",
        status: "200",
        tags: "test"
      }

      assert {:ok, %IntegrationLog{} = integration_log} =
               IntegrationLogs.create_integration_log(valid_attrs)

      assert integration_log.integration_type == "some integration_type"
      assert integration_log.endpoint == "some endpoint"
    end

    test "create_integration_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = IntegrationLogs.create_integration_log(@invalid_attrs)
    end

    test "update_integration_log/2 with valid data updates the integration_log" do
      integration_log = integration_log_fixture()

      update_attrs = %{
        integration_type: "some updated integration_type",
        endpoint: "some updated endpoint"
      }

      assert {:ok, %IntegrationLog{} = integration_log} =
               IntegrationLogs.update_integration_log(integration_log, update_attrs)

      assert integration_log.integration_type == "some updated integration_type"
      assert integration_log.endpoint == "some updated endpoint"
    end

    test "update_integration_log/2 with invalid data returns error changeset" do
      integration_log = integration_log_fixture()

      assert {:error, %Ecto.Changeset{}} =
               IntegrationLogs.update_integration_log(integration_log, @invalid_attrs)

      assert integration_log == IntegrationLogs.get_integration_log!(integration_log.id)
    end

    test "delete_integration_log/1 deletes the integration_log" do
      integration_log = integration_log_fixture()
      assert {:ok, %IntegrationLog{}} = IntegrationLogs.delete_integration_log(integration_log)

      assert_raise Ecto.NoResultsError, fn ->
        IntegrationLogs.get_integration_log!(integration_log.id)
      end
    end

    test "change_integration_log/1 returns a integration_log changeset" do
      integration_log = integration_log_fixture()
      assert %Ecto.Changeset{} = IntegrationLogs.change_integration_log(integration_log)
    end
  end
end
