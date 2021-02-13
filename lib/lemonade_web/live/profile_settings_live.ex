defmodule LemonadeWeb.ProfileSettingsLive do
  use LemonadeWeb, :live_view

  @impl true
  def mount(_, %{"user_token" => user_token}, socket) do
    current_organization_member = Lemonade.Tenancy.get_organization_member_from_user_token(user_token)
    organization = current_organization_member.organization
    team = Lemonade.Teams.get_team_by_organization(organization)
    changeset = Lemonade.Organizations.change_organization_member(current_organization_member)

    {:ok,
      socket
      |> allow_upload(:avatar, accept: ~w(.png .jpeg .jpg))
      |> assign(:team, team)
      |> assign(:current_organization_member, current_organization_member)
      |> assign(:changeset, changeset)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, LemonadeWeb.LayoutComponent,
      id: "logged-in-layout",
      current_organization_member: @current_organization_member,
      team: @team do %>

      <%= live_component @socket, LemonadeWeb.SettingsLayoutComponent, current_organization_member: @current_organization_member, live_action: @live_action do %>
        <div class="mb-4">
          <%= live_patch "change avatar", to: Routes.settings_path(@socket, :avatar) %>
        </div>

        <%= f = form_for @changeset, "#", phx_submit: "update-organization-member" %>
          <%= text_input f, :name %>

          <%= live_file_input @uploads.avatar %>
          <%= submit "Update" %>
        </form>
      <% end %>

      <%= if @modal_id == :avatar do %>
        <%= live_modal @socket, LemonadeWeb.AvatarFormComponent, return_to: Routes.settings_path(@socket, :profile) %>
      <% end %>
    <% end %>
    """
  end

  @impl true
  def handle_event("update-organization-member", %{"organization_member" => attrs}, socket) do
    {:ok, organization_member} =
      Lemonade.Organizations.update_organization_member(socket.assigns.current_organization_member, attrs)

    {:noreply,
      socket
      |> assign(:current_organiztion_member, organization_member)}
  end
end
