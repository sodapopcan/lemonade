defmodule LemonadeWeb.SetupLive do
  use LemonadeWeb, :live_view
  use Phoenix.HTML

  alias Lemonade.{Accounts, Organizations}

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    organization = Organizations.get_organization_by_owner(current_user)
    team = load_team(organization)
    if team do
      {:ok, redirect(socket, to: "/standup")}
    else
      {:ok, assign(socket, current_user: current_user, organization: organization, team: team, errors: [])}
    end
  end

  def render(assigns) do
    ~L"""
    <%= if !@organization do %>
      <%= live_component @socket, LemonadeWeb.OrganizationSetupComponent, errors: @errors %>
    <% end %>

    <%= if @organization && !@team do %>
      <h1><%= @organization.name %></h1>
      <%= live_component @socket, LemonadeWeb.TeamSetupComponent, errors: @errors %>
    <% end %>

    <div><%= link "logout", to: Routes.user_session_path(@socket, :delete), method: :delete %></div>
    """
  end

  def handle_event(
        "create-organization",
        %{"organization" => organization_params},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    case Organizations.create_organization(current_user, organization_params) do
      {:ok, organization} -> {:noreply, assign(socket, organization: organization)}
      {:error, %{errors: errors}} -> {:noreply, assign(socket, errors: errors)}
    end
  end

  def handle_event(
        "create-team",
        %{"team" => team_params},
        %{assigns: %{current_user: current_user, organization: organization}} = socket
      ) do
    case Organizations.create_team(current_user, organization, team_params) do
      {:ok, _} -> {:noreply, redirect(socket, to: "/standup")}
      {:error, %{errors: errors}} -> {:noreply, assign(socket, errors: errors)}
    end
  end

  defp load_team(%{id: _id} = organization), do: Organizations.get_team_by_organization(organization)
  defp load_team(_), do: nil
end
