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
        <%= live_component @socket, LemonadeWeb.NewStickyComponent, id: @sticky_lane.id %>
      </div>
    </section>
    """
  end

  @impl true
  def handle_event("update-name", %{"id" => id, "content" => name} = attrs, socket) do
    {:ok, _sticky_lane} = Lemonade.Teams.get_sticky_lane!(id)
    |> Lemonade.Teams.update_sticky_lane(%{"name" => name})

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _sticky_lane} = Lemonade.Teams.delete_sticky_lane(id)

    {:noreply, socket}
  end
end
