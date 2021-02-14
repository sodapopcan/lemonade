defmodule LemonadeWeb.StickyLaneComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <h1><%= @sticky_lane.name %></h1>
    </section>
    """
  end
end
