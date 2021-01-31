defmodule LemonadeWeb.VacationComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex flex-start items-center">
      <%= icon "calendar", class: "w-4 h-4 mr-2" %>
      <%= live_patch icon("plus"), to: Routes.team_path @socket, :vacations %>
      <div id="vacations" phx-update="append" class="flex">
        <%= for vacation <- @vacations do %>
          <div id="<%= vacation.id %>" class="flex items-center text-xs mx-1 bg-gray-50 rounded-full shadow">
            <div class="centered py-1 px-2 bg-gray-100 rounded-full">
              <%= initials(vacation.team_member.name) %>
            </div>
            <div class="py-1 px-2 mr-1 rounded-r-full">
              <%= if @current_team_member == vacation.team_member do %>
                <%= live_patch format_date_range(vacation.starts_at, vacation.ends_at), to: "?vacation=#{vacation.id}" %>
              <% else %>
                <%= format_date_range vacation.starts_at, vacation.ends_at %>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>

      <%= if @live_action == :vacations do %>
        <%= live_modal @socket, LemonadeWeb.VacationFormComponent,
        id: :new,
        return_to: Routes.team_path(@socket, :index) %>
      <% end %>
    </div>
    """
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
