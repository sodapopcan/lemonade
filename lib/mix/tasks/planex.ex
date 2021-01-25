defmodule Mix.Tasks.Planex do
  use Mix.Task

  @shortdoc "Info about these tasks"
  def run(_) do
    IO.puts("Well, not for now")
  end

  defmodule Seed do
    use Mix.Task

    @shortdoc "Seeds development data with the Planet Express organization"
    @requirements ["app.start"]
    def run(_) do
      [prof | staff] = [
        {"Professor Hubert Farnsworth", "professor"},
        {"Leela", "leela"},
        {"Philip J Fry", "philip"},
        {"Bender Bending Rodríguez", "bender"},
        {"Amy Wong", "amy"}
      ]

      Ecto.Multi.new()
      |> Ecto.Multi.run(:user, fn _repo, _ ->
        {name, email} = prof

        Lemonade.Accounts.register_user(%{
          name: name,
          email: "#{email}@planetexpress.com",
          password: "Password12345"
        })
      end)
      |> Ecto.Multi.run(:organization, fn _repo, %{user: user} ->
        Lemonade.Organizations.bootstrap_organization(
          user,
          %{
            "name" => "Planet Express",
            "teams" => [%{"name" => "Delivery Team"}]
          }
        )
      end)
      |> Ecto.Multi.run(:staff, fn _repo, %{organization: %{teams: [team | _]} = organization} ->
        staff =
          Enum.map(staff, fn {name, email} ->
            {:ok, user} =
              Lemonade.Accounts.register_user(%{
                name: name,
                email: "#{email}@planetexpress.com",
                password: "Password12345"
              })

            Lemonade.Accounts.join_organization(user, organization)

            {:ok, organization_member} =
              Lemonade.Organizations.join_organization(organization, user)

            {:ok, team_member} = Lemonade.Teams.join_team(team, organization_member)

            # Lemonade.Teams.join_standup(team.standup |> Lemonade.Repo.preload(:standup_members), team_member)
            user
          end)

        {:ok, staff}
      end)
      |> Lemonade.Repo.transaction()
    end
  end

  defmodule Unseed do
    use Mix.Task

    @shortdoc "Destroys the planex seed"
    @requirements ["app.start"]
    def run(_) do
      Ecto.Adapters.SQL.query!(Lemonade.Repo, "UPDATE users SET organization_id = null WHERE email LIKE '%@planetexpress.com'")

      Ecto.Adapters.SQL.query!(
        Lemonade.Repo,
        "DELETE FROM organizations WHERE name = 'Planet Express'"
      )

      Ecto.Adapters.SQL.query!(
        Lemonade.Repo,
        "DELETE FROM users WHERE email LIKE '%@planetexpress.com'"
      )
    end
  end
end
