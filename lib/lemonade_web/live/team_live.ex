defmodule LemonadeWeb.TeamLive do
  use LemonadeWeb, :live_view

  alias LemonadeWeb.{LayoutComponent, VacationComponent, StandupComponent, StickiesComponent}
  alias Lemonade.{Teams, Tenancy}
  alias Lemonade.Teams.TeamPresence

  @impl true
  def mount(_, %{"user_token" => user_token}, socket) do
    current_organization_member = Tenancy.get_organization_member_from_user_token(user_token)
    organization = current_organization_member.organization
    team = Teams.get_team_by_organization(organization)
    standup = Teams.get_standup_by_team(team)
    sticky_lanes = Teams.list_sticky_lanes(team)

    current_team_member =
      Teams.get_team_member_by_organization_member(team, current_organization_member)

    vacations = Teams.get_vacations_by_team(team)

    if connected?(socket) do
      TeamPresence.start_tracking(self(), current_team_member)
      Teams.subscribe(team.id)
    end

    present_team_member_ids = TeamPresence.list_team_member_ids(current_team_member)

    {:ok,
     assign(
       socket,
       current_organization_member: current_organization_member,
       current_team_member: current_team_member,
       present_team_member_ids: present_team_member_ids,
       team: team,
       standup: standup,
       vacations: vacations,
       sticky_lanes: sticky_lanes,
       modal_id: nil
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, LayoutComponent,
      id: "logged-in-layout",
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
          present_team_member_ids: @present_team_member_ids,
          standup: @standup %>
      </div>

      <div class="px-4 pt-2">
        <%= live_component @socket, StickiesComponent,
          id: "stick-lanes",
          current_team_member: @current_team_member,
          team: @team,
          sticky_lanes: @sticky_lanes %>
      </div>

      <%= if @live_action == :settings do %>
        <%= live_modal @socket, LemonadeWeb.TeamSettingsFormComponent,
        id: "team-settings",
        current_team_member: @current_team_member,
        team: @team,
        return_to: Routes.team_path(@socket, :index) %>
      <% end %>
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
  def handle_info({:team_updated, team}, socket) do
    {:noreply, update(socket, :team, fn _ -> team end)}
  end

  def handle_info({:standup_updated, standup}, socket) do
    {:noreply, update(socket, :standup, fn _ -> standup end)}
  end

  def handle_info({:vacation_updated, _vacation}, socket) do
    {:noreply,
      socket
      |> assign(:vacations, Teams.get_vacations_by_team(socket.assigns.team))
      |> assign(:standup, Teams.get_standup_by_team(socket.assigns.team))}
  end

  def handle_info({:sticky_lanes_updated, _sticky_lane}, socket) do
    {:noreply,
      socket
      |> assign(:sticky_lanes, Teams.list_sticky_lanes(socket.assigns.team))}
  end

  # Presence

  def handle_info(%{event: "presence_diff"}, socket) do
    present_team_member_ids = TeamPresence.list_team_member_ids(socket.assigns.current_team_member)

    {:noreply, assign(socket, :present_team_member_ids, present_team_member_ids)}
  end
end
