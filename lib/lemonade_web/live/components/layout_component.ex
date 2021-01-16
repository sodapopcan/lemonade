defmodule LemonadeWeb.LayoutComponent do
  use LemonadeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div>
      <div>
        <h1>Lemonade</h1>
        <p><%= @current_user.email %>
      </div>
      <div class="content">
        <%= render_block(@inner_block) %>
      </div>
    </div>
    """
  end
end
