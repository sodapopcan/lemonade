defmodule LemonadeWeb.LayoutComponent do
  use LemonadeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="w-screen">
      <div class="flex items-center bg-yellow-500 py-2 px-3 text-sm">
        <div class="flex-1">
          <h1 class="text-base">Lemonade</h1>
        </div>
        <p><%= @current_user.name %></p>

        <div class="group relative">
          <a href="<%= Routes.user_settings_path(@socket, :edit) %>" class="bg-yellow-400 w-6 h-6 rounded-full p-0 ml-2 text-xs flex justify-center items-center">AH</a>
          <ul class="group-hover:visible absolute right-0 rounded border border-yellow-500 bg-yellow-400 p-2">
            <li class="text-right"><%= link "settings", to: Routes.user_settings_path(@socket, :edit) %></li>
            <li class="text-right"><%= link "logout", to: Routes.user_session_path(@socket, :delete), method: :delete %></li>
          </ul>
        </div>
      </div>
      <div class="p-2">
        <%= render_block(@inner_block) %>
      </div>
    </div>
    """
  end
end
