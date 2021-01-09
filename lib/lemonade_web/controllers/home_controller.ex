defmodule LemonadeWeb.HomeController do
  use LemonadeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
