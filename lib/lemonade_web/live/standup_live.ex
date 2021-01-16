defmodule LemonadeWeb.StandupLive do
  use LemonadeWeb, :live_view

  alias Lemonade.Accounts

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)

    {:ok, assign(socket, current_user: current_user)}
  end

  def render(assigns) do
    ~L"""
    <div>Hi, <%= @current_user.email %></div>
    """
  end
end
