defmodule LemonadeWeb.TeamLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, Organizations, Teams}
  alias LemonadeWeb.{LayoutComponent, StandupComponent}

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    current_organization_member = Organizations.get_organization_member_by_user(current_user)
    organization = Organizations.get_organization_by_organization_member(current_organization_member)
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
      <div class="px-4 pt-2 flex flex-start items-center">
        <%= icon "calendar", class: "w-4 h-4 mr-2" %>
        <div class="flex items-center bold text-xs p-2">
          <div class="font-bold centered mr-2">PF</div>
          <div class="mr-2">Mar 10-13</div>
        </div>
        <div class="relative" x-data="{ open: false }">
          <a href="#" @click="open = true"><%= icon "plus" %></a>
          <div x-show="open" @click.away="open = false" class="absolute -left-2 -top-2 p-2 w-96 rounded bg-yellow-400 shadow-md">
            <h1>Time Off</h1>
            <div>
              <button type="radio">all day</button>
            </div>
            <div>
              <button type="radio">morning</button>
            </div>
            <div>
              <button type="radio">afternoon</button>
            </div>
          </div>
        </div>
      </div>
      <div class="px-4 pt-2">
        <%= live_component @socket, StandupComponent, id: "standup", current_team_member: @current_team_member, standup: @standup %>
      </div>
    <% end %>
    """
  end

  def handle_info({:standup_updated, standup}, socket) do
    {:noreply, update(socket, :standup, fn _ -> standup end)}
  end
end
