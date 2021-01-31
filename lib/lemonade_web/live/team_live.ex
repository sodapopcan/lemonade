defmodule LemonadeWeb.TeamLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, Organizations, Teams}
  alias LemonadeWeb.{LayoutComponent, VacationComponent, StandupComponent}

  @impl true
  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    current_organization_member = Organizations.get_organization_member_by_user(current_user)
    organization = Organizations.get_organization_by_organization_member(current_organization_member)
    team = Teams.get_team_by_organization(organization)
    standup = Teams.get_standup_by_team(team)
    current_team_member =
      Teams.get_team_member_by_organization_member(team, current_organization_member)
    vacations = Teams.get_vacations_by_team(team)

    if connected?(socket), do: Teams.subscribe(team.id)

    {:ok,
     assign(
       socket,
       organization: organization,
       current_organization_member: current_organization_member,
       current_team_member: current_team_member,
       team: team,
       standup: standup,
       vacations: vacations,
       vacation_id: nil
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, LayoutComponent,
      id: "logged-in-layout",
      organization: @organization,
      current_organization_member: @current_organization_member,
      team: @team do %>

      <div class="px-4 pt-2">
        <%= live_component @socket, VacationComponent,
          id: "vacation-component",
          current_team_member: @current_team_member,
          vacations: @vacations,
          vacation_id: @vacation_id,
          live_action: @live_action %>
      </div>

      <div class="px-4 pt-2">
        <%= live_component @socket, StandupComponent,
          id: "standup",
          current_team_member: @current_team_member,
          standup: @standup %>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply, assign(socket, vacation_id: id)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:standup_updated, standup}, socket) do
    {:noreply, update(socket, :standup, fn _ -> standup end)}
  end

  def handle_info({:vacation_updated, _vacation}, socket) do
    {:noreply, assign(socket, vacations: Teams.get_vacations_by_team(socket.assigns.team))}
  end
end
