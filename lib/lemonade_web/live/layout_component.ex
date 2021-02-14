defmodule LemonadeWeb.LayoutComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-screen" x-data="{mainTitle: 'Lemonade', teamMenuOpen: false, userMenuOpen: false}">
      <div class="flex items-center bg-yellow-500 text-sm">
        <div class="flex-1 px-1">
          <%= if @team do %>
            <div class="flex">
              <h1 class="text-base font-semibold"><%= @team.organization.name %></h1>
              <div class="mx-2">|</div>
              <h2 class="text-base"><%= live_patch @team.name, to: Routes.team_path(@socket, :index) %></h2>
            </div>
          <% else %>
            <h1 class="text-base" x-html="mainTitle">Lemonade</h1>
          <% end %>
        </div>
        <div>
          <ul class="absolute right-0 rounded border border-yellow-500 bg-yellow-400 p-2" x-show="teamMenuOpen" @click.away="teamMenuOpen = false">
          </ul>
        </div>

        <div class="relative flex">
          <a href="#" @click="userMenuOpen = true" class="p-1"><%= avatar(@current_organization_member, :small) %></a>
          <ul class="absolute top-10 right-0 w-32 rounded-bl bg-yellow-400 p-2 shadow-md" x-show="userMenuOpen" @click.away="userMenuOpen = false">
            <li class="text-right"><%= live_patch "settings", to: Routes.settings_path(@socket, :user) %></li>
            <li class="text-right"><%= live_patch "team settings", to: Routes.team_path(@socket, :settings) %></li>
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
