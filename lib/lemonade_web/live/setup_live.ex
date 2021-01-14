defmodule LemonadeWeb.SetupLive do
  use LemonadeWeb, :live_view
  use Phoenix.HTML

  alias Lemonade.{Accounts, Organizations}

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    organization = Organizations.get_organization_by_owner(current_user)
    {:ok, assign(socket, current_user: current_user, organization: organization, errors: [])}
  end

  def render(assigns) do
    ~L"""
    <%= if !@organization, do: live_component @socket, LemonadeWeb.OrganizationSetupComponent, errors: @errors %>
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
end
