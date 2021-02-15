defmodule LemonadeWeb.StickyLaneComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <header class="flex items-center">
        <h1 class="mr-2"><%= @sticky_lane.name %></h1>

        <%= live_patch icon("x"), to: "#",
          phx_click: "delete",
          phx_value_id: @sticky_lane.id,
          phx_target: @myself %>
      <header>
    </section>
    """
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, sticky_lane} = Lemonade.Teams.delete_sticky_lane(id)

    {:noreply, socket}
  end
end
