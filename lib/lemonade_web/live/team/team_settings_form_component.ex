defmodule LemonadeWeb.TeamSettingsFormComponent do
  use LemonadeWeb, :live_component

  alias Lemonade.Teams

  def update(%{current_team_member: current_team_member, team: team}, socket) do
    changeset = Teams.edit_team_changeset(team)

    {:ok,
      socket
      |> assign(:changeset, changeset)
      |> assign(:current_team_member, current_team_member)
      |> assign(:team, team)}
  end

  def render(assigns) do
    ~L"""
    <div id="team-settings-form" class="p-4 w-96 rounded bg-yellow-400 shadow-md" phx-hook="DateRangePicker">
      <%= f = form_for @changeset, "#", phx_submit: "update-team-settings", phx_target: @myself %>
        <%= label f, :name %>
        <%= text_input f, :name %>

        <section>
          <h1 class="font-bold pb-2">Standup</h1>
          <%= inputs_for f, :standup, fn ff -> %>
            <%= label ff, :starts_at %>
            <%= text_input ff, :starts_at %>

            <%= label ff, :randomized %>
            <%= checkbox ff, :randomized %>
          <% end %>
        </section>

        <div class="text-right">
          <%= live_patch "Cancel", to: Routes.team_path(@socket, :index), class: "button" %>
          <button type="submit" class="button-primary bg-yellow-200" phx-click="close" phx-target="#modal">OK</button>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("update-team-settings", %{"team" => attrs}, socket) do
    {:ok, _team} = Teams.update_team(socket.assigns.team, attrs)
    {:noreply, socket}
  end
end
