defmodule LemonadeWeb.StandupComponent do
  use LemonadeWeb, :live_component

  def render(assigns) do
    ~L"""
    <section>
      <header class="flex flex-start items-center">
        <h1 class="pb-2 text-xl">Standup</h1>
        <div class="px-4 pb-2 opacity-0 group-hover:opacity-100">
          <%= if attending_standup?(@current_team_member, @standup) do %>
            <a href="#" phx-click="leave-standup" title="leave standup" class="leave-standup-link"><%= icon("log-out") %></a>
          <% end %>
        </div>
      </header>
      <div class="flex items-center h-20">
        <%= for standup_member <- @standup.standup_members do %>
          <div class="h-20 w-20 bg-yellow-300 rounded-full centered text-2xl"><%= initials(standup_member.team_member.name) %></div>
        <% end %>
        <%= if !attending_standup?(@current_team_member, @standup) do %>
          <div class="flex flex-start">
            <a href="#" phx-click="join-standup" class="join-standup-link flex flex-start items-center"><%= icon "log-in" %> <span class="ml-2">join standup</span></a>
          </div>
        <% end %>
      </div>
    </section>
    """
  end

  defp attending_standup?(current_team_member, standup) do
    Enum.any?(standup.standup_members, fn %{team_member: team_member} ->
      team_member.id == current_team_member.id
    end)
  end
end
