defmodule LemonadeWeb.SettingsLive do
  use LemonadeWeb, :live_view

  alias LemonadeWeb.LayoutComponent

  @impl true
  def mount(_, params, socket) do
    socket = assign_defaults(params, socket)
    organization = socket.assigns.current_organization_member.organization
    team = Lemonade.Teams.get_team_by_organization(organization)

    {:ok,
      socket
      |> assign(:team, team)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component LayoutComponent,
      id: "logged-in-layout",
      current_organization_member: @current_organization_member,
      team: @team do %>

      <p
        class="alert alert-info"
        role="alert"
        phx-click="lv:clear-flash"
        phx-value-key="info"><%= live_flash(@flash, :info) %></p>

      <p class="alert alert-danger"
        role="alert"
        phx-click="lv:clear-flash"
        phx-value-key="error"><%= live_flash(@flash, :error) %></p>

      <div class="w-96 mx-auto my-8">
        <div class="w-96 mx-auto mb-8 flex items-center flex-col">
            <%= avatar(@current_organization_member) %>
          <div class="mt-4"><%= @current_organization_member.name %></div>
        </div>

        <div class="list-reset flex justify-center mb-8">
          <%= menu_item(@socket, @live_action, "User", :user) %>
          <%= menu_item(@socket, @live_action, "Profile", :profile) %>
          <%= # menu_item(@socket, @live_action, "Team", :profile) %>
        </div>

        <%= if @live_action == :user, do: live_component @socket,
          LemonadeWeb.UserSettingsComponent,
          id: "user-settings-component",
          current_user: @current_user,
          current_organization_member: @current_organization_member
        %>
        <%= if @live_action == :profile, do: live_component @socket,
          LemonadeWeb.ProfileSettingsComponent,
          id: "profile-settings-component",
          modal_id: @modal_id,
          current_organization_member: @current_organization_member
        %>
      </div>

    <% end %>
    """
  end

  @impl true
  def handle_params(%{"modal_id" => modal_id}, _url, socket) do
    {:noreply,
      socket
      |> assign(:modal_id, modal_id)}
  end
  def handle_params(_, _, socket) do
    {:noreply,
      socket
      |> assign(:modal_id, nil)}
  end

  defp menu_item(socket, live_action, name, route) do
    border_color = if live_action == route, do: "border-yellow-600", else: ""
    class = "py-2 px-4 border-b #{border_color} hover:border-gray-400" 

    ~e"""
    <div>
      <%= live_patch name, to: Routes.settings_path(socket, route), class: class %>
    </div>
    """
  end
end
