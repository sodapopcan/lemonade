defmodule LemonadeWeb.StickiesComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="stickies">
      <%= for sticky_lane <- @sticky_lanes do %>
        <%= live_component @socket, LemonadeWeb.StickyLaneComponent,
          id: sticky_lane.id,
          sticky_lane: sticky_lane %>
      <% end %>

      <a href="#" phx-click="create-sticky-lane" phx-target="<%= @myself %>" class="a-muted flex items-center">
        <%= icon("plus", class: "mr-2") %>
        <span>create new lane</span>
      </a>
    </div>
    """
  end

  @impl true
  def handle_event("create-sticky-lane", _, socket) do
    {:ok, _lane} = Lemonade.Teams.create_sticky_lane(socket.assigns.team)

    {:noreply, socket}
  end
end
