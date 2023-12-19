defmodule FullstackTestWeb.TradingControllerTest do
  use FullstackTestWeb.ConnCase

  import Mock

  describe "submit/2" do
    test "submits transactions successfully", %{conn: conn} do
      # Arrange
      selected_company = "AAPL"
      transaction_person = "John Doe"
      shares_amount = "10"
      job_title = "Some Job Title"

      with_mock(File,
        read: fn _ ->
          {:ok,
           """
             {
               "data": [
                  [
                    320193,
                    "Apple Inc.",
                    "AAPL",
                    "Nasdaq"
                  ]
               ]
             }
           """}
        end
      ) do
        # Act
        conn =
          conn
          |> post(
            "/api/submit",
            %{
              "selectedCompany" => selected_company,
              "transactionPerson" => transaction_person,
              "sharesAmount" => shares_amount,
              "jobTitle" => job_title
            }
          )

        # Assert success
        assert json_response(conn, 200)
      end
    end
  end

  describe "index/2" do
    test "returns list of companies successfull", %{conn: conn} do
      # Arrange
      with_mock(File,
        read: fn _ ->
          {:ok,
           """
             {
               "data": [
                  [
                    320193,
                    "Apple Inc.",
                    "AAPL",
                    "Nasdaq"
                  ]
               ]
             }
           """}
        end
      ) do
        # Act
        conn =
          conn
          |> get("/api/companies")

        # Assert success
        assert json_response(conn, 200)
      end
    end
  end
end
