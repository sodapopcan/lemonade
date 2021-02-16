defmodule LemonadeWeb.StickyComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div
      class="bg-<%= @sticky.color %>-200 group flex flex-col w-36 h-36 p-1 text-sm shadow-md mr-3 mb-3"
      style="cursor: grab"
    >
      <div class="flex justify-end invisible group-hover:visible">
        <a href="#" class="a-muted" phx-click="delete" phx-value-id="<%= @id %>" phx-target="<%= @myself %>">
          <%= icon("x") %>
        </a>
      </div>

      <div
        id="<%= @id %>"
        class="flex-1 centered text-center p-2 outline-none"
        contenteditable
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
end
