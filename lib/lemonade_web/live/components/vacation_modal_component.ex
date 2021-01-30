defmodule LemonadeWeb.VacationModalComponent do
  use LemonadeWeb, :live_component

  alias Lemonade.Teams
  alias Lemonade.Teams.Vacation

  def mount(socket) do
    changeset = Teams.change_vacation(%Vacation{}, %{type: "all day"})

    {:ok, assign(socket, changeset: changeset)}
  end


  def render(assigns) do
    ~L"""
    <div class="relative" id="time-off-selector" x-data="{ open: false }">
      <a href="#" @click="open = true" class="centered py-1 px-2"><%= icon "plus" %></a>
      <div x-show="open", class="phx-modal centered" @click="open = false">
        <div x-on:click.stop class="p-4 w-96 rounded bg-yellow-400 shadow-md">
          <%= f = form_for @changeset, "#", x_ref: "form", phx_submit: "book-time-off", phx_target: @myself %>
            <h1>Vacation</h1>
            <div id="date-rage-picker-wrapper" phx-update="ignore" class="centered p-4">
              <input type="hidden" id="date-range-picker" />
              <%= hidden_input f, :starts_at, id: "vacation-starts-at" %>
              <%= hidden_input f, :ends_at, id: "vacation-ends-at" %>
            </div>
            <div class="flex justify-between mx-8">
              <%= labeled_radio_button f, :type, "all day" %>
              <%= labeled_radio_button f, :type, "morning" %>
              <%= labeled_radio_button f, :type, "afternoon" %>
            </div>
            <div class="text-right">
              <button type="button" class="button" @click="open = false; $refs.form.reset()">Cancel</button>
              <button type="submit" class="button-primary bg-yellow-200">OK</button>
          </form>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("book-time-off", %{"vacation" => attrs}, %{assigns: assigns} = socket) do
    %{current_team_member: current_team_member} = assigns
    Teams.book_vacation(current_team_member, attrs)

    {:noreply, socket}
  end
end
