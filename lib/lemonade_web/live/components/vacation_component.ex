defmodule LemonadeWeb.VacationComponent do
  use LemonadeWeb, :live_component

  alias Lemonade.Teams
  alias Lemonade.Teams.Vacation

  def mount(socket) do
    changeset = Teams.change_vacation(%Vacation{}, %{type: "all day"})

    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns) do
    ~L"""
    <div class="flex flex-start items-center">
      <%= icon "calendar", class: "w-4 h-4 mr-2" %>
      <div id="vacations" phx-update="append" class="flex">
        <%= for vacation <- @vacations do %>
          <div id="<%= vacation.id %>" class="flex items-center bold text-xs p-2">
            <div class="font-bold centered mr-2"><%= initials vacation.team_member.name %></div>
            <div class="mr-2"><%= format_date_range vacation.starts_at, vacation.ends_at %></div>
          </div>
        <% end %>
      </div>

      <div class="relative" id="time-off-selector" x-data="{ open: false }">
        <a href="#" @click="open = true"><%= icon "plus" %></a>
          <%= f = form_for @changeset, "#", x_show: "open", class: "absolute -left-2 -top-2 p-2 w-96 rounded bg-yellow-400 shadow-md", x_ref: "form", phx_submit: "book-time-off", phx_target: @myself %>
          <h1>Time Off</h1>
          <div id="date-rage-picker-wrapper" phx-update="ignore" class="centered p-4">
            <input type="hidden" id="date-range-picker" />
            <%= hidden_input f, :starts_at, id: "vacation-starts-at" %>
            <%= hidden_input f, :ends_at, id: "vacation-ends-at" %>
          </div>
          <div class="flex justify-between mx-8">
            <label>
              <%= radio_button f, :type, "all day" %>
              all day
            </label>
            <label>
              <%= radio_button f, :type, "morning" %>
              morning
            </label>
            <label>
              <%= radio_button f, :type, "afternoon" %>
              afternoon
            </label>
          </div>
          <div class="text-right">
            <button type="button" @click="open = false; $refs.form.reset()">Cancel</button>
            <button type="submit">OK</button>
          </div>
        </form>
      </div>
    </div>
    """
  end

  def handle_event("book-time-off", %{"vacation" => attrs}, %{assigns: assigns} = socket) do
    %{current_team_member: current_team_member} = assigns
    Teams.book_vacation(current_team_member, attrs)

    {:noreply, socket}
  end

  def format_date_range(starts_at, ends_at) do
    fstarts_at = format(starts_at, "%b %-d")
    fends_at = format_ends_at(starts_at, ends_at)

    raw "#{fstarts_at}#{fends_at}"
  end

  defp format_ends_at(date, date = ends_at), do: ""

  defp format_ends_at(%{month: month}, %{month: month} = ends_at) do
    format(ends_at, "&ndash;%-d")
  end

  defp format_ends_at(starts_at, ends_at) do
    format(ends_at, "&ndash;%b %-d")
  end
  defp format(date, pattern), do: Timex.format!(date, pattern, :strftime)
end
