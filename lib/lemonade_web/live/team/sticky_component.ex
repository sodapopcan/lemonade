defmodule LemonadeWeb.StickyComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
      <div
        class="bg-<%= @sticky.color %>-200 w-36 h-36 p-4 text-sm centered text-center outline-none shadow-md mr-3 mb-3"
        id="<%= @id %>"
        class="note-content"
        data-event="create"
        data-id="<%= @id %>"
        data-phx-target="<%= @myself %>"
        contenteditable
        phx-hook="ContentEditable"
        phx-blur="cancel"
        phx-target="<%= @myself %>"
      ><%= @sticky.content %></div>
    """
  end
end
