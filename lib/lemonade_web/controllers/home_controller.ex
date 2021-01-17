defmodule LemonadeWeb.HomeController do
  use LemonadeWeb, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
