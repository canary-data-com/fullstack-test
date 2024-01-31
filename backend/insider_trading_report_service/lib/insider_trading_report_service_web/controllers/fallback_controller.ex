defmodule InsiderTradingReportServiceWeb.FallbackController do
  use InsiderTradingReportServiceWeb, :controller

  alias InsiderTradingReportServiceWeb.ErrorJSON

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: ErrorJSON)
    |> render(:"500")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(404)
    |> put_view(json: ErrorJSON)
    |> render(:"404", message: reason)
  end

  # def foo do
  #   InsiderTradingReportServiceWeb.FallbackController.call(%Plug.Conn{adapter: {Plug.Cowboy.Conn, :...}, assigns: %{}, body_params: %{}, cookies: %{}, halted: false, host: "localhost", method: "GET", owner: #PID<0.806.0>, params: %{"ticker" => "AAPL"}, path_info: ["api", "insiders", "AAPL", "transactions"], path_params: %{"ticker" => "AAPL"}, port: 4000, private: %{:phoenix_view => %{"html" => InsiderTradingReportServiceWeb.InsidersHTML, "json" => InsiderTradingReportServiceWeb.InsidersJSON}, InsiderTradingReportServiceWeb.Router => [], :phoenix_action => :index, :phoenix_layout => %{"html" => {InsiderTradingReportServiceWeb.Layouts, :app}}, :phoenix_controller => InsiderTradingReportServiceWeb.InsidersController, :phoenix_endpoint => InsiderTradingReportServiceWeb.Endpoint, :phoenix_format => "json", :phoenix_router => InsiderTradingReportServiceWeb.Router, :plug_session_fetch => #Function<1.76384852/1 in Plug.Session.fetch_session/1>, :before_send => [#Function<0.54455629/1 in Plug.Telemetry.call/2>], :phoenix_request_logger => {"request_logger", "request_logger"}}, query_params: %{}, query_string: "", remote_ip: {127, 0, 0, 1}, req_cookies: %{}, req_headers: [{"accept", "*/*"}, {"accept-encoding", "gzip, deflate, br"}, {"cache-control", "no-cache"}, {"connection", "keep-alive"}, {"host", "localhost:4000"}, {"postman-token", "a2079f8c-2823-4b06-b44c-fb71d6b76792"}, {"user-agent", "PostmanRuntime/7.32.1"}], request_path: "/api/insiders/AAPL/transactions", resp_body: nil, resp_cookies: %{}, resp_headers: [{"cache-control", "max-age=0, private, must-revalidate"}, {"access-control-allow-credentials", "true"}, {"access-control-allow-origin", "*"}, {"access-control-expose-headers", ""}, {"x-request-id", "F69I9m5lQAQtDrUAAAMk"}], scheme: :http, script_name: [], secret_key_base: :..., state: :unset, status: nil}, {:error, "Ticker AAPL Not Found."})
  # end
end
