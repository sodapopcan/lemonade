defmodule LemonadeWeb.ProfileSettingsComponent do
  use LemonadeWeb, :live_component

  @impl true
  def update(assigns, socket) do
    changeset =
      Lemonade.Organizations.change_organization_member(assigns.current_organization_member)

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
      <%= f = form_for @changeset, "#", phx_submit: "update-organization-member", phx_target: @myself %>
        <%= label f, :name %>
        <%= text_input f, :name %>

        <div class="mb-4">
          <%= label f, :avatar_url, "Avatar" %>
          <%= live_file_input @uploads.avatar, class: "w-full text-xs" %>
        </div>

        <div>
          <%= submit "Update", class: "button-primary" %>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def handle_event("update-organization-member", %{"organization_member" => attrs}, socket) do
    case Lemonade.Organizations.update_organization_member(
      socket.assigns.current_organization_member,
      attrs
    ) do
      {:ok, organization_member} ->
        {:noreply,
          socket
          |> put_flash(:info, "Updated organization member")
          |> push_redirect(to: Routes.settings_path(socket, :profile))}

      {:error, _error} ->
        {:noreply, socket}
    end
  end
end
