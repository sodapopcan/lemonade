defmodule LemonadeWeb.StandupComponent do
  use LemonadeWeb, :live_component

  alias Lemonade.Teams

  @impl true
  def render(assigns) do
    ~L"""
    <section class="mb-4 group">
      <header class="flex flex-start items-center">
        <h1 class="pb-2 text-xl">Standup</h1>
        <div class="px-4 pb-2 opacity-0 flex flex-start group-hover:opacity-100">
          <%= if attending_standup?(@current_team_member, @standup) do %>
            <a href="#" phx-click="leave-standup" phx-target="<%= @myself %>" title="Leave standup" class="leave-standup-link ml-2"><%= icon("log-out") %></a>
            <a href="#" phx-click="shuffle-standup" phx-target="<%= @myself %>" title="Randomize standup" class="shuffle-standup-link ml-2"><%= icon("refresh-cw") %></a>
          <% end %>
        </div>
      </header>
      <div class="flex items-center h-20">
        <%= for standup_member <- @standup.standup_members do %>
          <div class="w-20 h-20 bg-yellow-300 rounded-full centered text-2xl mr-2 shadow"><%= initials(standup_member.name) %></div>
        <% end %>
        <%= if !attending_standup?(@current_team_member, @standup) do %>
          <div class="flex flex-start">
            <a href="#" phx-click="join-standup" phx-target="<%= @myself %>" class="join-standup-link h-20 w-20 hover:bg-gray-200 rounded-full centered text-center mr-2"><%= icon "log-in" %></a>
          </div>
        <% end %>
      </div>
    </section>
    """
  end

  @impl true
  def handle_event("join-standup", _, %{assigns: assigns} = socket) do
    %{standup: standup, current_team_member: current_team_member} = assigns
    {:ok, _standup} = Teams.join_standup(standup, current_team_member)

    {:noreply, socket}
  end

  def handle_event("leave-standup", _, %{assigns: assigns} = socket) do
    %{standup: standup, current_team_member: current_team_member} = assigns
    {:ok, _standup} = Teams.leave_standup(standup, current_team_member)

    {:noreply, socket}
  end

  def handle_event("shuffle-standup", _, %{assigns: %{standup: standup}} = socket) do
    Teams.shuffle_standup(standup)
    {:noreply, socket}
  end

  defp attending_standup?(current_team_member, standup) do
    Enum.any?(standup.standup_members, fn %{team_member_id: team_member_id} ->
      team_member_id == current_team_member.id
    end)
  end
end
