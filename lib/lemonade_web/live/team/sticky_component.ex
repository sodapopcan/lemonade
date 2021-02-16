defmodule LemonadeWeb.StickyComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div
      class="bg-<%= @sticky.color %>-200 group flex flex-col w-36 h-36 p-1 text-sm shadow-md mr-3 mb-3"
      style="cursor: grab"
      id="sticky-wrapper-<%= @id %>"
    >
      <div class="flex justify-end invisible group-hover:visible">
        <a href="#" class="a-muted mr-1" phx-click="toggle-completed" phx-value-id="<%= @id %>" phx-target="<%= @myself %>">
          <%= if @sticky.completed, do: icon("check-square"), else: icon("square") %>
        </a>

        <a href="#" class="a-muted" phx-click="delete" phx-value-id="<%= @id %>" phx-target="<%= @myself %>">
          <%= icon("x") %>
        </a>
      </div>

      <div
        id="<%= @id %>"
        class="flex-1 centered text-center p-2 outline-none"
        data-id="<%= @id %>"
        data-event="update"
        data-phx-target="<%= @myself %>"
        phx-hook="ContentEditable"
        ><%= @sticky.content %></div>

      <div class="flex invisible group-hover:visible">
        <div class="w-3 h-3 mr-1 rounded-full bg-yellow-100"></div>
        <div class="w-3 h-3 mr-1 rounded-full bg-green-200"></div>
        <div class="w-3 h-3 mr-1 rounded-full bg-blue-200"></div>
        <div class="w-3 h-3 mr-1 rounded-full bg-yellow-600"></div>
        <div class="w-3 h-3 mr-1 rounded-full bg-green-800"></div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    Lemonade.Teams.get_sticky!(id)
    |> Lemonade.Teams.delete_sticky()
    {:noreply, socket}
  end

  def handle_event("update", %{"id" => id} = attrs, socket) do
    Lemonade.Teams.get_sticky!(id)
    |> Lemonade.Teams.update_sticky(attrs)
    {:noreply, socket}
  end

  def handle_event("toggle-completed", %{"id" => id}, socket) do
    Lemonade.Teams.get_sticky!(id)
    |> Lemonade.Teams.toggle_completed_sticky()
    {:noreply, socket}
  end
end
