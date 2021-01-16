defmodule LemonadeWeb.HomeLive do
  use LemonadeWeb, :live_view
  alias Lemonade.Accounts

  def mount(_, %{"user_token" => user_token}, socket) do
    if Accounts.get_user_by_session_token(user_token) do
      {:ok, redirect(socket, to: Routes.setup_path(socket, :index))}
    else
      {:ok, assign(socket, show: nil)}
    end
  end

  def mount(_, _, socket) do
    {:ok, assign(socket, current_user: nil, show: nil)}
  end

  def handle_params(_params, url, socket) do
    cond do
      url =~ "login" -> {:noreply, assign(socket, show: "login")}
      url =~ "register" -> {:noreply, assign(socket, show: "login")}
      true -> {:noreply, assign(socket, show: nil)}
    end
  end

  def handle_params(_, _, socket), do: {:noreply, socket}

  def render(assigns) do
    ~L"""
    <div class="w-screen h-screen bg-yellow-400 flex justify-center items-center">
      <div class="relative">
        <div class="absolute w-12 h-12 top-1 -left-14 z-0 text-5xl"><%= live_patch "🍋", to: "/" %></div>
        <h1 class="title text-5xl font-thin relative z-10">Lemonade</h2>
        <nav class="relative left-1">
          <%= live_patch "Login", to: "/login" %> or
          <%= link "Register", to: Routes.user_registration_path(@socket, :new) %>
        </nav>

        <div class="login mt-4 <%= if @show == "login", do: "", else: "hidden" %>">
          <%= f = form_for :user, Routes.user_session_path(@socket, :create), [as: :user] %>
            <%= email_input f, :email, placeholder: "email", required: true, phx_hook: "Focus" %>

            <%= password_input f, :password, placeholder: "password", required: true %>

            <div class="flex center-items space-between">
              <%= checkbox f, :remember_me, class: "inline mr-2" %>
              <%= label f, :remember_me, "Keep me logged in for 60 days", class: "text-xs inline" %>
            </div>

            <div>
              <%= submit "Log in" %>
            </div>
          </form>
        </div>
      </div>
    </div>
    """
  end
end
