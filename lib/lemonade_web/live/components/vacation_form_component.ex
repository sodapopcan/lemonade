defmodule LemonadeWeb.VacationFormComponent do
  use LemonadeWeb, :live_component

  alias Lemonade.Teams
  alias Lemonade.Teams.Vacations.Vacation

  @impl true
  def update(%{id: :new, current_team_member: current_team_member}, socket) do
    changeset = Teams.change_vacation(%Vacation{}, %{type: "all day"})

    {:ok, assign(socket, changeset: changeset, current_team_member: current_team_member)}
  end

  def update(%{id: id}, socket) do
    vacation = Teams.get_vacation!(id)
    changeset = Teams.change_vacation(vacation, %{})

    {:ok, assign(socket, changeset: changeset, vacation: vacation)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id="vacation-form" class="p-4 w-96 rounded bg-yellow-400 shadow-md" phx-hook="DateRangePicker">
      <%= f = form_for @changeset, "#", phx_submit: submit_action(@changeset), phx_target: @myself %>
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
          <%= live_patch "Cancel", to: Routes.team_path(@socket, :index), class: "button" %>
          <button type="submit" class="button-primary bg-yellow-200" phx-click="close" phx-target="#modal">OK</button>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def handle_event("book-vacation", %{"vacation" => attrs}, socket) do
    socket.assigns.current_team_member |> Teams.book_vacation(attrs)

    {:noreply, socket}
  end

  def handle_event("update-vacation", %{"vacation" => attrs}, socket) do
    socket.assigns.vacation |> Teams.update_vacation(attrs)

    {:noreply, socket}
  end

  defp submit_action(%{data: %{id: nil}}), do: "book-vacation"
  defp submit_action(_changeset), do: "update-vacation"
end
