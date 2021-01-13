defmodule LemonadeWeb.SetupLive do
  use LemonadeWeb, :live_view
  use Phoenix.HTML

  alias Lemonade.{Accounts, Organizations}

  @default_assigns [
    current_user: nil,
    organization_errors: []
  ]

  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    {:ok, assign(socket, current_user: current_user, organization_errors: [])}
  end

  def render(assigns) do
    ~L"""
    <h1>Welcome</h1>

    <p>To get started, enter the name of your organization.  If this is for personal use, just use your name.</p>

    <%= f = form_for :organization, "#", phx_submit: "create-organization", errors: @organization_errors %>
      <%= label f, :name %>
      <%= text_input f, :name, phx_hook: "Focus" %>
      <%= error_tag f, :name %>
      <%= submit "Go" %>
    </form>

    <p>
      If you wish to join an existing organization, you must request an invite.
      Please contact the appropriate party to request an invite.
    </p>

    <div><%= link "logout", to: Routes.user_session_path(@socket, :delete), method: :delete %></div>
    """
  end

  def handle_event(
        "create-organization",
        %{"organization" => organization_params},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    case Organizations.create_organization(current_user, organization_params) do
      {:ok, organization} -> {:noreply, assign(socket, organization: organization)}
      {:error, %{errors: errors}} -> {:noreply, assign(socket, organization_errors: errors)}
    end
  end
end
