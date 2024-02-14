defmodule TradingWeb.PageController do
  use TradingWeb, :controller

  def index(conn, _params) do
    # Your code here
    render(conn, "index.html")
  end
end
