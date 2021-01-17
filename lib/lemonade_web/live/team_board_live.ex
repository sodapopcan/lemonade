defmodule LemonadeWeb.TeamBoardLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, Organizations}

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    organization = Organizations.get_organization_by_owner(current_user)
    if organization do
      {:ok, assign(socket, current_user: current_user)}
    else
      {:ok, redirect(socket, to: "/setup")}
    end
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LemonadeWeb.LayoutComponent, id: "logged-in-layout", current_user: @current_user do %>
      <div>I'm the main content</div>
    <% end %>
    """
  end
end
