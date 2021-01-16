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
    <div class="w-screen h-screen bg-yellow-400 flex justify-center items-center">
      <div>
        <h1 class="title text-5xl">Lemonade</h2>
        <nav>
          <%= link "Login", to: Routes.user_session_path(@socket, :new) %> or
          <%= link "Register", to: Routes.user_registration_path(@socket, :new) %>
        </nav>
      </div>
    </div>
    """
  end
end
