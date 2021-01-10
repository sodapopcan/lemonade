defmodule LemonadeWeb.SetupLive do
  use LemonadeWeb, :live_view

  def render(assigns) do
    ~L"""
    <div>I'm the dashboard!</div>
    <div><%= link "logout", to: Routes.user_session_path(@socket, :delete), method: :delete %></div>
    """
  end
end
