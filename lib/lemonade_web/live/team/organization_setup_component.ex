defmodule LemonadeWeb.OrganizationSetupComponent do
  use LemonadeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <p>To get started, enter the name of your organization.  If this is for personal use, just use your name.</p>

    <%= f = form_for :organization, "#", phx_submit: "create-organization", errors: @errors %>
      <%= label f, :name %>
      <%= text_input f, :name, phx_hook: "Focus" %>
      <%= error_tag f, :name %>
      <%= submit "Go" %>
    </form>

    <p>
      If you wish to join an existing organization, you must request an invite.
      Please contact the appropriate party to request an invite.
    </p>
    """
  end
end
