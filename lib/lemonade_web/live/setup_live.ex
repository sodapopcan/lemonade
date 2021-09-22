defmodule LemonadeWeb.SetupLive do
  use LemonadeWeb, :live_view
  use Phoenix.HTML

  alias Lemonade.Organizations

  @impl true
  def mount(_, params, socket) do
    socket = assign_defaults(params, socket)

    if socket.assigns.current_organization_member do
      {:ok, redirect(socket, to: "/team")}
    else
      changeset = Organizations.bootstrap_organization_changeset(%{teams: [%{}]})

      {:ok,
       assign(socket,
         current_user: socket.assigns.current_user,
         changeset: changeset,
         errors: []
       )}
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component LemonadeWeb.LayoutComponent, id: "logged-in-layout", team: nil, organization: nil, current_organization_member: @current_user do %>
      <div class="w-screen h-screen flex justify-center items-center">
        <div class="relative w-1/4">
          <div class="mb-4">
            <div class="absolute w-12 h-12 top-1 -left-14 z-0 text-5xl"><%= live_patch "🍋", to: "/" %></div>
              <h1 class="title text-5xl font-thin relative z-10 mb-4">Welcome</h1>
              <%= f = form_for @changeset, "#", phx_submit: "bootstrap-organization" %>
                <section>
                  <p class="mb-4">It looks like you don't belong to an organization in the system, so there is a bit of setup to do.</p>
                </section>

                <section>
                  <h2 class="font-semibold">Organization</h2>
                  <p class="p-2 text-sm">
                    Name your organization anything you like.
                  </p>
                    <%= text_input f, :name, [{:"x-on:keyup", "const {target:{value}} = $event; (value!=='') ? mainTitle = value : mainTitle = 'Lemonade'"}, required: true, autofocus: true, placeholder: "organization name"] %>
                  <%= error_tag f, :name %>
                </section>

                <section>
                  <%= for ff <- inputs_for f, :teams do %>
                    <h2 class="font-semibold">Team</h2>
                    <p class="p-2 text-sm">
                      Being a collaborative tool, you need to create at least one team.  It can be anything you like!
                      You will be automatically added to this team (you can always leave it later).
                    </p>
                    <%= text_input ff, :name, required: true, placeholder: "team name"%>
                    <%= error_tag ff, :name %>
                  <% end %>
                </section>

                <div>
                  <%= submit "Go!" %>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_event("bootstrap-organization", %{"organization" => organization_params}, socket) do
    case Organizations.bootstrap_organization(socket.assigns.current_user, organization_params) do
      {:ok, _organization} ->
        {:noreply, redirect(socket, to: Routes.team_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
