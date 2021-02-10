defmodule LemonadeWeb.UserSettingsLive do
  use LemonadeWeb, :live_view

  alias LemonadeWeb.{LayoutComponent}
  alias Lemonade.{Accounts, Teams, Organizations, Tenancy}
  alias Lemonade.Organizations.OrganizationMember

  @impl true
  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    current_organization_member = Tenancy.get_organization_member_from_user_token(user_token)
    organization = current_organization_member.organization
    team = Teams.get_team_by_organization(organization)

    {:ok,
     socket
     |> allow_upload(:avatar, accept: ~w(.png .jpeg .jpg))
     |> assign(:team, team)
     |> assign(:current_user, current_user)
     |> assign(:current_organization_member, current_organization_member)
     |> assign(:email_changeset, Accounts.change_user_email(current_user))
     |> assign(:password_changeset, Accounts.change_user_password(current_user))
     |> assign(
       :organization_member_changeset,
       Organizations.change_organization_member(current_organization_member)
     )}
  end

  @impl true
  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("update-organization-member", _params, socket) do
    [url | _] = get_avatar_urls(socket, socket.assigns.current_organization_member)

    {:ok, organization_member} =
      Organizations.update_organization_member(
        socket.assigns.current_organization_member,
        %{avatar_url: url},
        &consume_avatars(socket, &1)
      )

    {:noreply,
     socket
     |> assign(current_organization_member: organization_member)}
  end

  def handle_event("update-email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(socket, :confirm_email, &1)
        )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "A link to confirm your email change has been sent to the new address."
         )}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:email_changeset, changeset)}
    end
  end

  defp get_avatar_urls(socket, %OrganizationMember{} = organization_member) do
    {completed, []} = uploaded_entries(socket, :avatar)

    for entry <- completed do
      Routes.static_path(socket, "/uploads/#{organization_member.id}.#{ext(entry)}")
    end
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  def consume_avatars(socket, %OrganizationMember{} = organization_member) do
    consume_uploaded_entries(socket, :avatar, fn meta, entry ->
      dest = Path.join("priv/static/uploads", "#{organization_member.id}.#{ext(entry)}")
      File.cp!(meta.path, dest)
    end)

    {:ok, organization_member}
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
