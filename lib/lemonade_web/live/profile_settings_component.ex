defmodule LemonadeWeb.ProfileSettingsComponent do
  use LemonadeWeb, :live_component

  @impl true
  def update(assigns, socket) do
    changeset = Lemonade.Organizations.change_organization_member(assigns.current_organization_member)

    {:ok,
      socket
      |> allow_upload(:avatar, accept: ~w(.png .jpeg .jpg))
      |> assign(:current_organization_member, assigns.current_organization_member)
      |> assign(:changeset, changeset)
      |> assign(:modal_id, assigns.modal_id)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= f = form_for @changeset, "#", phx_submit: "update-organization-member" %>
      </form>

      <%= f = form_for @changeset, "#", phx_submit: "update-organization-member" %>
        <%= text_input f, :name %>

        <%= live_file_input @uploads.avatar %>
        <%= submit "Update" %>
      </form>
    </div>
    """
  end
end
