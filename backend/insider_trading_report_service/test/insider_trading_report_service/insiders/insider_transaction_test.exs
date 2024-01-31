defmodule InsiderTradingReportService.Insiders.InsiderTransactionTest do
  use InsiderTradingReportService.DataCase, async: true
  alias InsiderTradingReportService.Insiders.InsiderTransaction

  import InsiderTradingReportService.InsidersFixtures

  defp external_sample_data(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      name: "KONDO CHRISTOPHER",
      ticker: "AAPL",
      amount: 1_058_496,
      job_title: "Officer",
      market_cap: 2_907_455_619_072,
      shares: 5513,
      startDate: "2023-11-29"
    })
  end

  test "ticker, name, job_title, startDate, shares must be present" do
    changeset = InsiderTransaction.changeset(%InsiderTransaction{}, %{})

    assert %{
             name: ["can't be blank"],
             ticker: ["can't be blank"],
             job_title: ["can't be blank"],
             startDate: ["can't be blank"],
             shares: ["can't be blank"]
           } = errors_on(changeset)
  end

  test "after transform startDate should be of type Date" do
    insider_transactions =
      %InsiderTransaction{}
      |> InsiderTransaction.transform(external_sample_data())

    assert not is_binary(insider_transactions.startDate)
  end

  test "after transform shares should be of type Float" do
    insider_transactions =
      %InsiderTransaction{}
      |> InsiderTransaction.transform(external_sample_data())

    assert is_float(insider_transactions.shares)
  end

  test "after transform market_cap_percentage should be set" do
    insider_transactions =
      %InsiderTransaction{}
      |> InsiderTransaction.transform(external_sample_data())

    assert not is_nil(insider_transactions.market_cap_percentage)
  end

  test "market_cap_percentage should be nil if amount not present" do
    insider_transactions =
      %InsiderTransaction{}
      |> InsiderTransaction.transform(external_sample_data(%{amount: nil}))

    assert is_nil(insider_transactions.market_cap_percentage)
  end

  test "market_cap_percentage should be nil if market_cap not present" do
    insider_transactions =
      %InsiderTransaction{}
      |> InsiderTransaction.transform(external_sample_data(%{market_cap: nil}))

    assert is_nil(insider_transactions.market_cap_percentage)
  end

  test "should set timestamps" do
    insider_transactions =
      %InsiderTransaction{}
      |> InsiderTransaction.transform(external_sample_data())
      |> InsiderTransaction.set_timestamps()

    assert not is_nil(insider_transactions.inserted_at)
    assert not is_nil(insider_transactions.updated_at)
  end

  test "should convert to map keeping the id" do
    map =
      insider_transaction_fixture()
      |> InsiderTransaction.to_map(true)

    assert not is_nil(map.id)
  end

  test "should convert to map deleting the id" do
    map =
      insider_transaction_fixture()
      |> InsiderTransaction.to_map()

    assert is_nil(Map.get(map, :ïd))
  end
end
