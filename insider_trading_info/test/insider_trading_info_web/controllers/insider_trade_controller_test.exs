defmodule InsiderTradingInfoWeb.InsiderTradeControllerTest do
  use InsiderTradingInfoWeb.ConnCase

  import InsiderTradingInfo.TradingFixtures

  alias InsiderTradingInfo.Trading.InsiderTrade

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all insider_trades", %{conn: conn} do
      conn = get(conn, ~p"/api/insider_trades")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create insider_trade" do
    test "renders insider_trade when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/insider_trades", insider_trade: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/insider_trades/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/insider_trades", insider_trade: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update insider_trade" do
    setup [:create_insider_trade]

    test "renders insider_trade when data is valid", %{
      conn: conn,
      insider_trade: %InsiderTrade{id: id} = insider_trade
    } do
      conn = put(conn, ~p"/api/insider_trades/#{insider_trade}", insider_trade: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/insider_trades/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, insider_trade: insider_trade} do
      conn = put(conn, ~p"/api/insider_trades/#{insider_trade}", insider_trade: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete insider_trade" do
    setup [:create_insider_trade]

    test "deletes chosen insider_trade", %{conn: conn, insider_trade: insider_trade} do
      conn = delete(conn, ~p"/api/insider_trades/#{insider_trade}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/insider_trades/#{insider_trade}")
      end
    end
  end

  defp create_insider_trade(_) do
    insider_trade = insider_trade_fixture()
    %{insider_trade: insider_trade}
  end
end
