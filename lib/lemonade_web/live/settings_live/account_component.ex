defmodule LemonadeWeb.SettingsLive.AccountComponent do
  use LemonadeWeb, :live_component

  def render(assigns) do
    ~L"""
      <div>
        <section class="mb-8">
          <h1 class="text-lg font-semibold mb-4">Change email</h1>
          <%= f = form_for @email_changeset, "#", id: "user-settings-form", phx_submit: "update-email" %>
          <%= hidden_input f, :action, name: "action", value: "update_email" %>

          <%= email_input f, :email, required: true, placeholder: @current_organization_member.email %>
          <%= error_tag f, :email %>

          <%= password_input f, :current_password, required: true, name: "current_password", placeholder: "current password", id: "current_password_for_email" %>
          <%= error_tag f, :current_password %>

          <input type="submit" value="Change email" class="button-primary" />
          </form>
        </section>

        <section>
          <h1 class="text-lg font-semibold mb-4">Change password</h1>
          <%= form_for @password_changeset, Routes.user_settings_path(@socket, :update), fn f -> %>
            <%= if @password_changeset.action do %>
              <div class="alert alert-danger">
                <p>Oops, something went wrong! Please check the errors below.</p>
              </div>
            <% end %>

            <%= hidden_input f, :action, name: "action", value: "update_password" %>

            <%= password_input f, :password, required: true, placeholder: "new password" %>
            <%= error_tag f, :password %>

            <%= password_input f, :password_confirmation, required: true, placeholder: "confirm new password"%>
            <%= error_tag f, :password_confirmation %>

            <%= password_input f, :current_password, required: true, placeholder: "current password", name: "current_password", id: "current_password_for_password" %>
            <%= error_tag f, :current_password %>

            <%= submit "Change password", class: "button-primary" %>
          <% end %>
        </section>
      </div>
    """
  end
end
