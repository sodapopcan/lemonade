defmodule LemonadeWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  def assign_defaults(%{"user_token" => user_token}, socket) do
    current_user = Lemonade.Accounts.get_user_by_session_token(user_token)
    current_organization_member = Lemonade.Tenancy.get_organization_member_from_user_token(user_token)

    socket
    |> assign(:current_user, current_user)
    |> assign(:current_organization_member, current_organization_member)
    |> assign(:modal_id, nil)
  end

  @doc """
  Renders a component inside the `LemonadeWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, LemonadeWeb.TestLive.FormComponent,
        id: @test.id || :new,
        action: @live_action,
        test: @test,
        return_to: Routes.test_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(LemonadeWeb.ModalComponent, modal_opts)
  end
end
