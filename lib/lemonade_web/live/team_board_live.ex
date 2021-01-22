defmodule LemonadeWeb.TeamBoardLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, TeamBoard}

  def mount(_, %{"user_token" => user_token}, socket) do
    with current_user <- Accounts.get_user_by_session_token(user_token),
         {:ok, team} <- TeamBoard.load_board(current_user),
         current_team_member <- TeamBoard.get_current_team_member(current_user, team) do
      {:ok, assign(socket, current_team_member: current_team_member, team: team)}
    else
      {:error, _} -> {:ok, redirect(socket, to: "/setup")}
    end
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LemonadeWeb.LayoutComponent, id: "logged-in-layout", current_user: @current_team_member.user, team: @team do %>
      <div class="px-4 pt-2 group">
        <%= live_component @socket, LemonadeWeb.StandupComponent, id: "stand-up", current_team_member: @current_team_member, standup: @team.standup %>
      </div>
    <% end %>
    """
  end

  def handle_event("join-standup", _, %{assigns: assigns} = socket) do
    standup = TeamBoard.join_standup(assigns.team.standup, assigns.current_team_member)
    %{team: team, current_team_member: current_team_member} = assigns
    team = put_in(team.standup, standup)
    current_team_member = TeamBoard.get_current_team_member(current_team_member.user, team)

    {:noreply, assign(socket, team: team, current_team_member: current_team_member)}
  end

  def handle_event("leave-standup", _, %{assigns: assigns} = socket) do
    %{team: team, current_team_member: current_team_member} = assigns
    {:ok, standup_member} = TeamBoard.leave_standup(team.standup, current_team_member)
    standup_members = Enum.reject(team.standup.standup_members, &(&1.id == standup_member.id))
    team = put_in(team.standup.standup_members, standup_members)
    current_team_member = TeamBoard.get_current_team_member(current_team_member.user, team)

    {:noreply, assign(socket, team: team, current_team_member: current_team_member)}
  end
end
