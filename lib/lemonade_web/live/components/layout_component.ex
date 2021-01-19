defmodule LemonadeWeb.LayoutComponent do
  use LemonadeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="w-screen" x-data="{mainTitle: 'Lemonade'}">
      <div class="flex items-center bg-yellow-500 py-2 px-3 text-sm">
        <div class="flex-1">
          <%= if @team do %>
            <h1 class="text-base"><%= @team.organization.name %> - <%= @team.name %></h1>
          <% else %>
            <h1 class="text-base" x-html="mainTitle">Lemonade</h1>
          <% end %>
        </div>
        <p><%= @current_user.name %></p>

        <div class="relative" x-data="{ open: false }">
          <a href="#" @click="open = true" class="bg-yellow-400 w-6 h-6 rounded-full p-0 ml-2 text-xs centered"><%= initials(@current_user.name) %></a>
          <ul class="absolute right-0 rounded border border-yellow-500 bg-yellow-400 p-2" x-show="open" @click.away="open = false">
            <li class="text-right"><%= link "settings", to: Routes.user_settings_path(@socket, :edit) %></li>
            <li class="text-right"><%= link "logout", to: Routes.user_session_path(@socket, :delete), method: :delete %></li>
          </ul>
        </div>
      </div>
      <div class="main-content p-2">
        <%= render_block(@inner_block) %>
      </div>
    </div>
    """
  end
end
