defmodule LemonadeWeb.StickyLaneComponent do
  use LemonadeWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(:changeset, Lemonade.Teams.change_sticky_lane(assigns.sticky_lane))
      |> assign(:sticky_lane, assigns.sticky_lane)
      |> assign(:edit_lane_id, nil)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <header class="flex items-center">
        <h1
          class="mr-2"
          id="<%= @sticky_lane.id %>"
          data-event="update-name"
          data-id="<%= @sticky_lane.id %>"
          data-phx-target="<%= @myself %>"
          phx-hook="ContentEditable"
        >
          <%= @sticky_lane.name %>
        </h1>

        <%= live_patch icon("edit"), to: "#",
          class: "a-muted mr-2",
          phx_click: "edit",
          phx_value_id: @sticky_lane.id,
          phx_target: @myself %>

        <%= live_patch icon("x"), to: "#",
          class: "a-muted mr-2",
          phx_click: "delete",
          phx_value_id: @sticky_lane.id,
          phx_target: @myself %>
      </header>

      <div class="flex">
        <div class="flex flex-wrap">
          <%= for sticky <- @sticky_lane.stickies do %>
            <%= live_component @socket, LemonadeWeb.StickyComponent, id: sticky.id, sticky: sticky %>
          <% end %>
          <%= live_component @socket, LemonadeWeb.NewStickyComponent, id: @sticky_lane.id %>
        </div>
      </div>
    </section>
    """
  end

  @impl true
  def handle_event("update-name", %{"id" => id, "content" => name}, socket) do
    {:ok, _sticky_lane} = Lemonade.Teams.get_sticky_lane!(id)
    |> Lemonade.Teams.update_sticky_lane(%{"name" => name})

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _sticky_lane} = Lemonade.Teams.delete_sticky_lane(id)

    {:noreply, socket}
  end
end
