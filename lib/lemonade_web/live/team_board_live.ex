defmodule LemonadeWeb.TeamBoardLive do
  use LemonadeWeb, :live_view

  alias Lemonade.{Accounts, TeamBoard}

  def mount(_, %{"user_token" => user_token}, socket) do
    with current_user <- Accounts.get_user_by_session_token(user_token),
         {:ok, team} <- TeamBoard.load_board(current_user) do
      {:ok, assign(socket, current_user: current_user, team: team)}
    else
      {:error, _} -> {:ok, redirect(socket, to: "/setup")}
    end
  end

  def render(assigns) do
    ~L"""
    <%= live_component @socket, LemonadeWeb.LayoutComponent, id: "logged-in-layout", current_user: @current_user, team: @team do %>
      <div class="px-4 pt-2">
        <section>
          <h1 class="pb-2">Standup</h1>
          <div class="flex items-center h-20">
            <%= link "+ join standup", to: "#" %>
          </div>
        </section>
      </div>
    <% end %>
    """
  end
end
