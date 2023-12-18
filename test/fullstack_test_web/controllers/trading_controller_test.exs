defmodule FullstackTestWeb.TradingControllerTest do
  use FullstackTestWeb.ConnCase, async: true

  import Mock

  describe "submit/2" do
    test "submits transactions successfully", %{conn: conn} do
      # Arrange
      selected_company = "AAPL"
      transaction_person = "John Doe"
      shares_amount = 10
      job_title = "Some Job Title"

      with_mock(HTTPoison,
        get: fn _url ->
          {:ok,
           %HTTPoison.Response{
             status_code: 200,
             body: """
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
             """
           }}
        end
      ) do
        # Act
        conn =
          conn
          |> post(
            "/submit",
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
end
