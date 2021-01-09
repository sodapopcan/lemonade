defmodule LemonadeWeb.HomeLive do
  use LemonadeWeb, :live_view

  def render(assigns) do
    ~L"""
    <div class="home-live">
      <h1 class="title">🍋 Lemonade</h2>
    </div>
    """
  end
end
