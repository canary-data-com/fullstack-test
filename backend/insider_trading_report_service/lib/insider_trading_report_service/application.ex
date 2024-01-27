defmodule InsiderTradingReportService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InsiderTradingReportServiceWeb.Telemetry,
      InsiderTradingReportService.Repo,
      {DNSCluster, query: Application.get_env(:insider_trading_report_service, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InsiderTradingReportService.PubSub},
      # Start a worker by calling: InsiderTradingReportService.Worker.start_link(arg)
      # {InsiderTradingReportService.Worker, arg},
      # Start to serve requests, typically the last entry
      InsiderTradingReportServiceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InsiderTradingReportService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InsiderTradingReportServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
