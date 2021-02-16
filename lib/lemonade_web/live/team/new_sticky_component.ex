defmodule LemonadeWeb.NewStickyComponent do
  use LemonadeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, show_new_note: false)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex">
      <div
        class="w-36 h-36 bg-white p-4 text-sm centered text-center outline-none shadow-md"
        style="<%= display @show_new_note %>"
        id="new-sticky-lane-<%= @id %>"
        data-event="create"
        data-id="<%= @id %>"
        data-phx-target="<%= @myself %>"
        contenteditable
        phx-hook="ContentEditable"
        phx-blur="cancel"
        phx-target="<%= @myself %>"
      ></div>

      <div class="w-36 h-36 centered">
        <a
          href="#"
          class="a-muted"
          style="<%= display !@show_new_note %>"
          data-lane-id="<%= @id %>"
          id="focus-new-sticky-<%= @id %>"
          phx-hook="FocusNewSticky"
          phx-click="new"
          phx-target="<%= @myself %>"
        ><%= icon("plus", class: "w-10 h-10") %></a>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("new", _, socket) do
    {:noreply, assign(socket, :show_new_note, true)}
  end

  def handle_event("cancel", _, socket) do
    {:noreply, assign(socket, :show_new_note, false)}
  end

  def handle_event("create", %{"id" => lane_id, "content" => content}, socket) do
    {:ok, sticky} = Lemonade.Teams.get_sticky_lane!(lane_id)
    |> Lemonade.Teams.create_sticky(%{content: content})
    {:noreply, socket}
  end
end
