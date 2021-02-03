defmodule LemonadeWeb.TeamLive do
  use LemonadeWeb, :live_view

  alias LemonadeWeb.{LayoutComponent, VacationComponent, StandupComponent}
  alias Lemonade.{Accounts, Organizations, Teams}
  alias Lemonade.Teams.TeamPresence

  @impl true
  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    current_organization_member = Organizations.get_organization_member_by_user(current_user)
    organization = Organizations.get_organization_by_organization_member(current_organization_member)
    team = Teams.get_team_by_organization(organization)
    standup = Teams.get_standup_by_team(team)
    current_team_member = Teams.get_team_member_by_organization_member(team, current_organization_member)
    vacations = Teams.get_vacations_by_team(team)

    if connected?(socket) do
      TeamPresence.start_tracking(self(), current_team_member)
      Teams.subscribe(team.id)
    end

    online_team_member_ids = TeamPresence.list_team_member_ids(current_team_member)

    {:ok,
     assign(
       socket,
       organization: organization,
       current_organization_member: current_organization_member,
       current_team_member: current_team_member,
       online_team_member_ids: online_team_member_ids,
       team: team,
       standup: standup,
       vacations: vacations,
       modal_id: nil
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
          vacation_id: @modal_id,
          live_action: @live_action %>
      </div>

      <div class="px-4 pt-2">
        <%= live_component @socket, StandupComponent,
          id: "standup",
          current_team_member: @current_team_member,
          online_team_member_ids: @online_team_member_ids,
          standup: @standup %>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_params(%{"modal_id" => modal_id}, _, socket) do
    {:noreply, assign(socket, modal_id: modal_id)}
  end

  def handle_params(_, _, socket) do
    {:noreply, assign(socket, modal_id: nil)}
  end

  @impl true
  def handle_info({:standup_updated, standup}, socket) do
    {:noreply, update(socket, :standup, fn _ -> standup end)}
  end

  def handle_info({:vacation_updated, _vacation}, socket) do
    {:noreply, assign(socket, vacations: Teams.get_vacations_by_team(socket.assigns.team))}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    online_team_member_ids = TeamPresence.list_team_member_ids(socket.assigns.current_team_member)

    {:noreply, assign(socket, :online_team_member_ids, online_team_member_ids)}
  end
end
