defmodule LemonadeWeb.ModalComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="phx-modal centered"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="p-4 w-96 rounded bg-yellow-400 shadow-md">
        <%= live_patch icon("x"), to: @return_to, class: "float-right p-2" %>
        <%= live_component @socket, @component, @opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_redirect(socket, to: socket.assigns.return_to)}
  end
end
