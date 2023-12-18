defmodule FullstackTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FullstackTestWeb.Telemetry,
      FullstackTest.Repo,
      {DNSCluster, query: Application.get_env(:fullstack_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FullstackTest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FullstackTest.Finch},
      # Start a worker by calling: FullstackTest.Worker.start_link(arg)
      # {FullstackTest.Worker, arg},
      # Start to serve requests, typically the last entry
      FullstackTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FullstackTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FullstackTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
