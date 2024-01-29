defmodule InsiderTradingReportService.InsidersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InsiderTradingReportService.Insiders` context.
  """

  @doc """
  Generate a insider_transaction.
  """
  def insider_transaction_fixture(attrs \\ %{}) do
    {:ok, insider_transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        job_title: "some job_title",
        market_cap: "120.5",
        market_cap_percentage: 120.5,
        name: "some name",
        shares: 120.5,
        startDate: ~D[2024-01-27],
        ticker: "some ticker"
      })
      |> InsiderTradingReportService.Insiders.create_insider_transaction()

    insider_transaction
  end
end
