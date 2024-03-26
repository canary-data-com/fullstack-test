defmodule InsiderTradingInfo.TradingTest do
  use InsiderTradingInfo.DataCase

  alias InsiderTradingInfo.Trading

  describe "insider_trades" do
    alias InsiderTradingInfo.Trading.InsiderTrade

    import InsiderTradingInfo.TradingFixtures

    @invalid_attrs %{}

    test "list_insider_trades/0 returns all insider_trades" do
      insider_trade = insider_trade_fixture()
      assert Trading.list_insider_trades() == [insider_trade]
    end

    test "get_insider_trade!/1 returns the insider_trade with given id" do
      insider_trade = insider_trade_fixture()
      assert Trading.get_insider_trade!(insider_trade.id) == insider_trade
    end

    test "create_insider_trade/1 with valid data creates a insider_trade" do
      valid_attrs = %{}

      assert {:ok, %InsiderTrade{} = insider_trade} = Trading.create_insider_trade(valid_attrs)
    end

    test "create_insider_trade/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_insider_trade(@invalid_attrs)
    end

    test "update_insider_trade/2 with valid data updates the insider_trade" do
      insider_trade = insider_trade_fixture()
      update_attrs = %{}

      assert {:ok, %InsiderTrade{} = insider_trade} =
               Trading.update_insider_trade(insider_trade, update_attrs)
    end

    test "update_insider_trade/2 with invalid data returns error changeset" do
      insider_trade = insider_trade_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Trading.update_insider_trade(insider_trade, @invalid_attrs)

      assert insider_trade == Trading.get_insider_trade!(insider_trade.id)
    end

    test "delete_insider_trade/1 deletes the insider_trade" do
      insider_trade = insider_trade_fixture()
      assert {:ok, %InsiderTrade{}} = Trading.delete_insider_trade(insider_trade)
      assert_raise Ecto.NoResultsError, fn -> Trading.get_insider_trade!(insider_trade.id) end
    end

    test "change_insider_trade/1 returns a insider_trade changeset" do
      insider_trade = insider_trade_fixture()
      assert %Ecto.Changeset{} = Trading.change_insider_trade(insider_trade)
    end
  end
end
