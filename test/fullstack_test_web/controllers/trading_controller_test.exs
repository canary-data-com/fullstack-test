defmodule FullstackTestWeb.TradingControllerTest do
  use FullstackTestWeb.ConnCase

  describe "submit/2" do
    test "submits transactions successfully", %{conn: conn} do
      # Act
      conn =
        conn
        |> post(
          "/api/submit",
          %{
            "selectedCompany" => "AAPL"
          }
        )

      # Assert success
      assert json_response(conn, 200)
    end
  end

  describe "index/2" do
    test "returns list of companies successfull", %{conn: conn} do
      # Act
      conn =
        conn
        |> get("/api/companies")

      # Assert success
      assert json_response(conn, 200)
    end
  end
end
