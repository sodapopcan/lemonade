defmodule Lemonade.Factory do
  alias Lemonade.Repo
  alias Lemonade.Accounts.User
  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Teams.{Team, TeamMember}
  alias Lemonade.Teams.Standups.{Standup, StandupMember}

  def build(:user) do
    uniq_int = uniq_int()

    %User{
      name: "User #{uniq_int}",
      email: "user#{uniq_int}@example.com",
      hashed_password: Bcrypt.hash_pwd_salt("valid password")
    }
  end

  def build(:organization) do
    %Organization{
      name: "Team #{uniq_int()}"
    }
  end

  def build(:organization_member) do
    user = create(:user)

    %OrganizationMember{
      name: user.name,
      email: user.email,
      added_by: user,
      user: user,
      organization: build(:organization)
    }
  end

  def build(:team) do
    %Team{
      name: "Team #{uniq_int()}",
      organization: build(:organization)
    }
  end

  def build(:team_member) do
    organization_member = build(:organization_member)

    %TeamMember{
      name: organization_member.name,
      organization_member: organization_member,
      team: build(:team)
    }
  end

  def build(:standup) do
    %Standup{
      team: build(:team)
    }
  end

  def build(:standup_member) do
    %StandupMember{
      standup: build(:standup)
    }
  end

  ## API
  #
  def build(factory_name, attrs),
    do: factory_name |> build() |> struct(attrs)

  def create(factory_name, attrs \\ []),
    do: build(factory_name, attrs) |> Repo.insert!()

  defp uniq_int, do: System.unique_integer([:positive])
end
