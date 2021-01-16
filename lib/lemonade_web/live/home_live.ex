defmodule LemonadeWeb.HomeLive do
  use LemonadeWeb, :live_view
  alias Lemonade.Accounts 

  def mount(_, %{"user_token" => user_token}, socket) do
    if Accounts.get_user_by_session_token(user_token) do
      {:ok, redirect(socket, to: Routes.setup_path(socket, :index))}
    else
      {:ok, socket}
    end
  end

  def mount(_, _, socket) do
    {:ok, assign(socket, current_user: nil)}
  end

  def render(assigns) do
    ~L"""
    <div class="w-screen h-screen bg-yellow-400">
      <h1 class="title">Lemonade</h2>
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
