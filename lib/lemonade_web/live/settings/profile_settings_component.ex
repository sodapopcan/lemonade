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
      <%= f = form_for @changeset, "#", phx_change: "validate", phx_submit: "update-organization-member", phx_target: @myself %>
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
    avatar_url = avatar_url(socket, socket.assigns.current_organization_member)
    attrs = Map.put(attrs, "avatar_url", avatar_url)

    case Lemonade.Organizations.update_organization_member(
      socket.assigns.current_organization_member,
      attrs,
      &consume_avatar(socket, &1)
    ) do
      {:ok, _organization_member} ->
        {:noreply,
          socket
          |> push_redirect(to: Routes.settings_path(socket, :profile))}

      {:error, _error} ->
        {:noreply, socket}
    end
  end

  def handle_event("validate", _, socket), do: {:noreply, socket}

  defp avatar_url(socket, organization_member) do
    Routes.static_path(socket, "/uploads/#{organization_member.id}.jpg")
  end

  def consume_avatar(socket, %Lemonade.Organizations.OrganizationMember{} = organization_member) do
    import Mogrify

    consume_uploaded_entries(socket, :avatar, fn meta, _entry ->
      open(meta.path)
      |> format("jpg")
      |> resize_to_fill("300x300")
      |> gravity("Center")
      |> save(in_place: true)

      dest = Path.join("priv/static/uploads", "#{organization_member.id}.jpg")
      File.cp!(meta.path, dest)
    end)
    {:ok, organization_member}
  end
end
