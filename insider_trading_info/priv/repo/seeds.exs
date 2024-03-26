# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InsiderTradingInfo.Repo.insert!(%InsiderTradingInfo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

company_info_seeds = [
  %{
    cik: 320_193,
    ticker: "AAPL",
    company_name: "Apple Inc.",
    data_availability_date: ~D[2023-01-01]
  },
  %{
    cik: 1_045_810,
    ticker: "NVDA",
    company_name: "NVIDIA CORP.",
    data_availability_date: ~D[2023-01-01]
  },
  %{
    cik: 789_019,
    ticker: "MSFT",
    company_name: "Microsoft Corporation",
    data_availability_date: ~D[2023-01-01]
  }
]

# Insert seed data into the database
Enum.each(company_info_seeds, fn seed ->
  InsiderTradingInfo.Repo.insert!(
    InsiderTradingInfo.CompanyInfo.changeset(%InsiderTradingInfo.CompanyInfo{}, seed)
  )
end)
