defmodule LemonadeWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      alias LemonadeWeb.Router.Helpers, as: Routes

      import Lemonade.Factory

      @endpoint LemonadeWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Lemonade.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Lemonade.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Lemonade.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
