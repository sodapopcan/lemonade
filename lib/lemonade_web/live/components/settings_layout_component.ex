defmodule LemonadeWeb.SettingsLayoutComponent do
  use LemonadeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="w-96 mx-auto my-8">
      <div class="w-96 mx-auto mb-8 flex items-center flex-col">
          <%= avatar(@current_organization_member) %>
        <div class="mt-4"><%= @current_organization_member.name %></div>
      </div>

      <div class="list-reset flex justify-center mb-8">
        <%= menu_item(@socket, @live_action, "User", :user) %>
        <%= menu_item(@socket, @live_action, "Profile", :profile) %>
        <%= menu_item(@socket, @live_action, "Team", :profile) %>
      </div>
      <%= render_block(@inner_block) %>
    </div>
    """
  end

  defp menu_item(socket, live_action, name, route) do
    border_color = if live_action == route, do: "border-gray-600", else: ""
    class = "py-2 px-4 border-b #{border_color} hover:border-gray-400" 

    ~e"""
    <div>
      <%= live_patch name, to: Routes.settings_path(socket, route), class: class %>
    </div>
    """
  end
end
