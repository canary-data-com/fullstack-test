defmodule InsiderTradingReportService.InsidersTest do
  use InsiderTradingReportService.DataCase

  alias InsiderTradingReportService.Insiders

  describe "insider_transactions" do
    alias InsiderTradingReportService.Insiders.InsiderTransaction

    import InsiderTradingReportService.InsidersFixtures

    @invalid_attrs %{
      name: nil,
      ticker: nil,
      job_title: nil,
      startDate: nil,
      shares: nil,
      amount: nil,
      market_cap: nil,
      market_cap_percentage: nil
    }

    test "list_insider_transactions/0 returns all insider_transactions" do
      insider_transaction = insider_transaction_fixture()
      assert Insiders.list_insider_transactions() == [insider_transaction]
    end

    test "get_insider_transaction!/1 returns the insider_transaction with given id" do
      insider_transaction = insider_transaction_fixture()
      assert Insiders.get_insider_transaction!(insider_transaction.id) == insider_transaction
    end

    test "create_insider_transaction/1 with valid data creates a insider_transaction" do
      valid_attrs = %{
        name: "some name",
        ticker: "some ticker",
        job_title: "some job_title",
        startDate: ~D[2024-01-27],
        shares: 120.5,
        amount: "120.5",
        market_cap: "120.5",
        market_cap_percentage: 120.5
      }

      assert {:ok, %InsiderTransaction{} = insider_transaction} =
               Insiders.create_insider_transaction(valid_attrs)

      assert insider_transaction.name == "some name"
      assert insider_transaction.ticker == "some ticker"
      assert insider_transaction.job_title == "some job_title"
      assert insider_transaction.startDate == ~D[2024-01-27]
      assert insider_transaction.shares == 120.5
      assert insider_transaction.amount == Decimal.new("120.5")
      assert insider_transaction.market_cap == Decimal.new("120.5")
      assert insider_transaction.market_cap_percentage == 120.5
    end

    test "create_insider_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Insiders.create_insider_transaction(@invalid_attrs)
    end

    test "update_insider_transaction/2 with valid data updates the insider_transaction" do
      insider_transaction = insider_transaction_fixture()

      update_attrs = %{
        name: "some updated name",
        ticker: "some updated ticker",
        job_title: "some updated job_title",
        startDate: ~D[2024-01-28],
        shares: 456.7,
        amount: "456.7",
        market_cap: "456.7",
        market_cap_percentage: 456.7
      }

      assert {:ok, %InsiderTransaction{} = insider_transaction} =
               Insiders.update_insider_transaction(insider_transaction, update_attrs)

      assert insider_transaction.name == "some updated name"
      assert insider_transaction.ticker == "some updated ticker"
      assert insider_transaction.job_title == "some updated job_title"
      assert insider_transaction.startDate == ~D[2024-01-28]
      assert insider_transaction.shares == 456.7
      assert insider_transaction.amount == Decimal.new("456.7")
      assert insider_transaction.market_cap == Decimal.new("456.7")
      assert insider_transaction.market_cap_percentage == 456.7
    end

    test "update_insider_transaction/2 with invalid data returns error changeset" do
      insider_transaction = insider_transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Insiders.update_insider_transaction(insider_transaction, @invalid_attrs)

      assert insider_transaction == Insiders.get_insider_transaction!(insider_transaction.id)
    end

    test "delete_insider_transaction/1 deletes the insider_transaction" do
      insider_transaction = insider_transaction_fixture()

      assert {:ok, %InsiderTransaction{}} =
               Insiders.delete_insider_transaction(insider_transaction)

      assert_raise Ecto.NoResultsError, fn ->
        Insiders.get_insider_transaction!(insider_transaction.id)
      end
    end

    test "change_insider_transaction/1 returns a insider_transaction changeset" do
      insider_transaction = insider_transaction_fixture()
      assert %Ecto.Changeset{} = Insiders.change_insider_transaction(insider_transaction)
    end
  end
end
