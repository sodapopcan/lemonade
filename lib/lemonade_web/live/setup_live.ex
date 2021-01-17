defmodule LemonadeWeb.SetupLive do
  use LemonadeWeb, :live_view
  use Phoenix.HTML

  alias Lemonade.{Accounts, Organizations}

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    organization = Organizations.get_organization_by_owner(current_user)
    team = load_team(organization)
    if team do
      {:ok, redirect(socket, to: "/team-board")}
    else
      {:ok, assign(socket, current_user: current_user, organization: organization, team: team, errors: [])}
    end
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LemonadeWeb.LayoutComponent, id: "logged-in-layout", current_user: @current_user do %>
      <div class="w-screen h-screen flex justify-center items-center">
        <div class="relative w-1/4">
          <div class="mb-4">
            <div class="absolute w-12 h-12 top-1 -left-14 z-0 text-5xl"><%= live_patch "🍋", to: "/" %></div>
              <h1 class="title text-5xl font-thin relative z-10 mb-4">Welcome</h1>
              <%= f = form_for :team, "#", phx_submit: "create-team", errors: @errors %>
                <%= label f, "Organization Name" %>
                <%= text_input f, :name, phx_hook: "Focus" %>
                <%= error_tag f, :name %>

                <%= label f, "Team Name" %>
                <%= text_input f, :name, phx_hook: "Focus" %>
                <%= error_tag f, :name %>

                <div><%= link "logout", to: Routes.user_session_path(@socket, :delete), method: :delete %></div>
              </form>
            </div>
          </div>
        </div>
      </div>
    <% end %>
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
      {:ok, _} -> {:noreply, redirect(socket, to: "/team-board")}
      {:error, %{errors: errors}} -> {:noreply, assign(socket, errors: errors)}
    end
  end

  defp load_team(%{id: _id} = organization), do: Organizations.get_team_by_organization(organization)
  defp load_team(_), do: nil
end
