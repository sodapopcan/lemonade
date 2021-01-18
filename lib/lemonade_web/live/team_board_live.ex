defmodule LemonadeWeb.TeamBoardLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, TeamBoard}

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    team = TeamBoard.load_board(current_user)

    if team do
      {:ok, assign(socket, current_user: current_user, team: team)}
    else
      {:ok, redirect(socket, to: "/setup")}
    end
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LemonadeWeb.LayoutComponent, id: "logged-in-layout", current_user: @current_user, team: @team do %>
      <h1><%= @team.organization.name %></h1>
    <% end %>
    """
  end
end
