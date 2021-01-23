defmodule LemonadeWeb.TeamLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, Teams}
  alias LemonadeWeb.{LayoutComponent, StandupComponent}

  def mount(_, %{"user_token" => user_token}, socket) do
    with current_user <- Accounts.get_user_by_session_token(user_token),
         {:ok, team} <- Teams.load_board(current_user),
         current_team_member <- Teams.get_current_team_member(current_user, team) do
      {:ok, assign(socket, current_team_member: current_team_member, team: team)}
    else
      {:error, _} -> {:ok, redirect(socket, to: "/setup")}
    end
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LayoutComponent, id: "logged-in-layout", current_user: @current_team_member.user, team: @team do %>
      <div class="px-4 pt-2 group">
        <%= live_component @socket, StandupComponent, id: "stand-up", current_team_member: @current_team_member, standup: @team.standup %>
      </div>
    <% end %>
    """
  end

  def handle_event("join-standup", _, %{assigns: assigns} = socket) do
    %{team: team, current_team_member: current_team_member} = assigns
    standup = Teams.join_standup(team.standup, current_team_member)

    {:noreply, assign(socket, team: put_in(team.standup, standup))}
  end

  def handle_event("leave-standup", _, %{assigns: assigns} = socket) do
    %{team: team, current_team_member: current_team_member} = assigns
    {:ok, standup_member} = Teams.leave_standup(team.standup, current_team_member)
    standup_members = Enum.reject(team.standup.standup_members, &(&1.id == standup_member.id))
    team = put_in(team.standup.standup_members, standup_members)

    {:noreply, assign(socket, team: team)}
  end
end
