defmodule LemonadeWeb.UserSettingsLive do
  use LemonadeWeb, :live_view

  alias LemonadeWeb.{LayoutComponent}
  alias Lemonade.{Accounts, Teams, Tenancy}

  @impl true
  def mount(_, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    current_organization_member = Tenancy.get_organization_member_from_user_token(user_token)
    organization = current_organization_member.organization
    team = Teams.get_team_by_organization(organization)

    {:ok,
     socket
     |> assign(:team, team)
     |> assign(:current_user, current_user)
     |> assign(:current_organization_member, current_organization_member)
     |> assign(:email_changeset, Accounts.change_user_email(current_user))
     |> assign(:password_changeset, Accounts.change_user_password(current_user))}
  end

  @impl true
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
end
