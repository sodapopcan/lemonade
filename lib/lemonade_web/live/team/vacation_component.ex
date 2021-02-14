defmodule LemonadeWeb.VacationComponent do
  use LemonadeWeb, :live_component

  alias Lemonade.Teams

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex flex-start items-center">
      <%= icon "calendar", class: "w-4 h-4 mr-2" %>
      <%= live_patch icon("plus"), to: Routes.team_path(@socket, :vacations), id: "add-vacation-link" %>
      <div id="vacations" class="flex">
        <%= for vacation <- @vacations do %>
          <div id="<%= vacation.id %>" class="group flex items-center text-xs mx-1 bg-gray-50 rounded-full shadow">
            <div class="centered bg-gray-100 rounded-full">
              <%= avatar(vacation.team_member.organization_member, :x_small) %>
            </div>
            <div class="py-1 px-2 mr-1 rounded-r-full flex items-center">
              <%= if @current_team_member.id == vacation.team_member.id do %>
                <%= live_patch format_date_range(vacation.starts_at, vacation.ends_at),
                  to: Routes.team_path(@socket, :vacations, vacation.id), class: "a mr-2" %>

                <%= link icon("x"), to: "#", class: "a-muted", phx_click: "cancel-vacation", phx_value_id: vacation.id, phx_target: @myself %> 
              <% else %>
                <%= format_date_range vacation.starts_at, vacation.ends_at %>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>

      <%= if @live_action == :vacations do %>
        <%= live_modal @socket, LemonadeWeb.VacationFormComponent,
        id: @vacation_id || :new,
        current_team_member: @current_team_member,
        return_to: Routes.team_path(@socket, :index) %>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("cancel-vacation", %{"id" => vacation_id}, socket) do
    Teams.get_vacation!(vacation_id) |> Teams.cancel_vacation()

    {:noreply, socket}
  end

  defp format_date_range(starts_at, ends_at) do
    fstarts_at = format(starts_at, "%b %-d")
    fends_at = format_ends_at(starts_at, ends_at)

    raw("#{fstarts_at}#{fends_at}")
  end

  defp format_ends_at(date, date), do: ""

  defp format_ends_at(%{month: month}, %{month: month} = ends_at) do
    format(ends_at, "&ndash;%-d")
  end

  defp format_ends_at(_starts_at, ends_at) do
    format(ends_at, "&ndash;%b %-d")
  end

  defp format(date, pattern), do: Timex.format!(date, pattern, :strftime)
end
