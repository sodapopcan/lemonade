defmodule LemonadeWeb.TeamLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, Organizations, Teams}
  alias LemonadeWeb.{LayoutComponent, StandupComponent}

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    organization = Organizations.get_organization_by_user(current_user)
    current_organization_member = Organizations.get_organization_member_by_user(current_user)
    team = Teams.get_team_by_organization(organization)
    standup = Teams.get_standup_by_team(team)
    current_team_member =
      Teams.get_team_member_by_organization_member(team, current_organization_member)

    if connected?(socket), do: Teams.subscribe(team.id)

    {:ok,
     assign(
       socket,
       organization: organization,
       current_organization_member: current_organization_member,
       current_team_member: current_team_member,
       team: team,
       standup: standup
     )}
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LayoutComponent, id: "logged-in-layout", organization: @organization, current_organization_member: @current_organization_member, team: @team do %>
      <div class="px-4 pt-2">
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
