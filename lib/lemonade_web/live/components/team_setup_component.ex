defmodule LemonadeWeb.TeamSetupComponent do
  use LemonadeWeb, :live_component

  def render(assigns) do
    ~L"""
    <p>With Lemonade being a collaborative tool, you need to create a team.</p>

    <%= f = form_for :team, "#", phx_submit: "create-team", errors: @errors %>
      <%= label f, :name %>
      <%= text_input f, :name, phx_hook: "Focus" %>
      <%= error_tag f, :name %>
      <%= submit "Go" %>
    </form>
    """
  end
end
