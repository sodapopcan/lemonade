defmodule LemonadeWeb.HomeLive do
  use LemonadeWeb, :live_view

  @valid_paths ~w(login register)

  @default_assigns [
    path: "/"
  ]

  def render(assigns) do
    ~L"""
    <div class="home-live">
      <h1 class="title">🍋 Lemonade</h2>
      <nav>
        <ul>
          <li><%= link "Login", to: Routes.user_session_path(@socket, :new) %> or</li>
          <li><%= link "Register", to: Routes.user_registration_path(@socket, :new) %></li>
        </ul>
      </nav>
    </div>
    """
  end
end
