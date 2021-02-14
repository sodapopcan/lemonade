defmodule LemonadeWeb.VacationFormComponent do
  use LemonadeWeb, :live_component

  alias Lemonade.Teams
  alias Lemonade.Teams.Vacations.Vacation

  @impl true
  def update(%{id: :new, current_team_member: current_team_member, return_to: return_to}, socket) do
    changeset = Teams.change_vacation(%Vacation{}, %{type: "all day"})
    vacations = get_other_vacation_days(current_team_member)

    {:ok,
      socket
      |> assign(changeset: changeset)
      |> assign(current_team_member: current_team_member)
      |> assign(return_to: return_to)
      |> push_event("vacations", %{vacations: vacations})}
  end

  def update(%{id: id, current_team_member: current_team_member, return_to: return_to}, socket) do
    vacation = Teams.get_vacation!(id)
    vacations = get_other_vacation_days(current_team_member, vacation)
    changeset = Teams.change_vacation(vacation, %{})

    {:ok,
      socket
      |> assign(changeset: changeset)
      |> assign(vacation: vacation)
      |> assign(return_to: return_to)
      |> push_event("vacations", %{vacations: vacations})}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id="vacation-form" phx-hook="DateRangePicker">
      <%= f = form_for @changeset, "#", phx_submit: submit_action(@changeset), phx_target: @myself %>
        <h1>Vacation</h1>

        <div id="date-rage-picker-wrapper" phx-update="ignore" class="block text-center p-4">
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
          <%= submit "OK", class: "button-primary bg-yellow-200" %>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def handle_event("book-vacation", %{"vacation" => attrs}, socket) do
    socket.assigns.current_team_member |> Teams.book_vacation(attrs)

    {:noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)}
  end

  def handle_event("update-vacation", %{"vacation" => attrs}, socket) do
    socket.assigns.vacation |> Teams.update_vacation(attrs)

    {:noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)}
  end

  defp submit_action(%{data: %{id: nil}}), do: "book-vacation"
  defp submit_action(_changeset), do: "update-vacation"

  defp get_other_vacation_days(team_member, vacation \\ %{id: nil}) do
    Teams.get_vacations_by_team_member(team_member)
      |> Enum.reject(fn %{id: id} -> vacation.id == id end)
      |> Enum.map(&extract_dates/1)
  end

  defp extract_dates(%{starts_at: starts_at, ends_at: ends_at}) do
    [format_date(starts_at), format_date(ends_at)]
  end

  defp format_date(%{year: year, month: month, day: day}), do: "#{year}-#{month}-#{day}"
end
