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
        <section>
        <header class="flex flex-start items-center">
          <h1 class="pb-2 text-xl">Standup</h1>
          <div class="px-4 pb-2 opacity-0 group-hover:opacity-100">
            <%= if attending_standup?(@current_team_member, @team.standup) do %>
              <a href="#" phx-click="leave-standup" title="leave standup" class="leave-standup-link"><%= icon("log-out") %></a>
            <% end %>
          </div>
        </header>
          <div class="flex items-center h-20">
            <%= for standup_member <- @team.standup.standup_members do %>
              <div class="h-20 w-20 bg-yellow-300 rounded-full centered text-2xl"><%= initials(standup_member.team_member.name) %></div>
            <% end %>
            <%= if !attending_standup?(@current_team_member, @team.standup) do %>
              <div class="flex flex-start">
                <a href="#" phx-click="join-standup" class="join-standup-link flex flex-start items-center"><%= icon "log-in" %> <span class="ml-2">join standup</span></a>
              </div>
            <% end %>
          </div>
        </section>
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
    standup_member = TeamBoard.leave_standup(assigns.current_team_member.standup_member)
    %{team: team, current_team_member: current_team_member} = assigns
    standup_members = Enum.reject(team.standup.standup_members, &(&1.id == standup_member.id))
    team = put_in(team.standup.standup_members, standup_members)
    current_team_member = TeamBoard.get_current_team_member(current_team_member.user, team)

    {:noreply, assign(socket, team: team, current_team_member: current_team_member)}
  end

  defp attending_standup?(current_team_member, standup) do
    Enum.any?(standup.standup_members, fn %{team_member: team_member} ->
      team_member.id == current_team_member.id
    end)
  end
end
