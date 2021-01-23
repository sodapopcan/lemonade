defmodule LemonadeWeb.TeamLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, Teams}
  alias LemonadeWeb.{LayoutComponent, StandupComponent}

  def mount(_, %{"user_token" => user_token}, socket) do
    with current_user <- Accounts.get_user_by_session_token(user_token),
         team <- Teams.get_team_by_user(current_user),
         standup <- Teams.get_standup_by_team(team),
         current_team_member <- Teams.get_current_team_member(current_user, team) do
      if connected?(socket), do: Teams.subscribe(team.id)

      {:ok, assign(socket, current_team_member: current_team_member, team: team, standup: standup)}
    else
      {:error, _} -> {:ok, redirect(socket, to: "/setup")}
    end
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LayoutComponent, id: "logged-in-layout", current_user: @current_team_member.user, team: @team do %>
      <div class="px-4 pt-2 group">
        <%= live_component @socket, StandupComponent, id: "standup", current_team_member: @current_team_member, standup: @standup %>
      </div>
    <% end %>
    """
  end

  def handle_info({:joined_standup, standup}, socket) do
    {:noreply, update(socket, :standup, fn _ -> standup end)}
  end

  def handle_info({:left_standup, standup}, socket) do
    {:noreply, update(socket, :standup, fn _ -> standup end)}
  end
end
