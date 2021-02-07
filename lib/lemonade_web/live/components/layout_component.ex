defmodule LemonadeWeb.LayoutComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-screen" x-data="{mainTitle: 'Lemonade', teamMenuOpen: false, userMenuOpen: false}">
      <div class="flex items-center bg-yellow-500 py-2 px-3 text-sm">
        <div class="flex-1">
          <%= if @team do %>
            <h1 class="text-base"><%= @team.organization.name %></h1>
          <% else %>
            <h1 class="text-base" x-html="mainTitle">Lemonade</h1>
          <% end %>
        </div>
        <div>
          <a href="#" class="inline-block flex items-center" @click="teamMenuOpen = true">
            <%= if @team do %>
              <span class="mr-1"><%= @team.name %></span>
            <% end %>
            <%= icon("chevron-down") %>
          </a>
          <ul class="absolute right-0 rounded border border-yellow-500 bg-yellow-400 p-2" x-show="teamMenuOpen" @click.away="teamMenuOpen = false">
            <li class="text-right" @click="teamMenuOpen = false"><%= live_patch "settings", to: Routes.team_path(@socket, :settings) %></li>
          </ul>
        </div>

        <div class="relative">
          <a href="#" @click="userMenuOpen = true" class="bg-yellow-400 w-6 h-6 rounded-full p-0 ml-2 text-xs centered"><%= initials(@current_organization_member.name) %></a>
          <ul class="absolute right-0 rounded border border-yellow-500 bg-yellow-400 p-2" x-show="userMenuOpen" @click.away="userMenuOpen = false">
            <li class="text-right"><%= live_patch "settings", to: Routes.settings_path(@socket, :account) %></li>
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
