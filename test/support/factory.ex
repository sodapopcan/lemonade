defmodule Lemonade.Factory do
  alias Lemonade.Repo
  alias Lemonade.Accounts.User
  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Teams.{Team, TeamMember}
  alias Lemonade.Teams.Standups.{Standup, StandupMember}
  alias Lemonade.Teams.Vacations.Vacation
  alias Lemonade.Teams.Stickies.{Sticky, StickyLane}

  def build(:user) do
    {name, email} = unique_user("User", "example.com")

    %User{
      name: name,
      email: email,
      hashed_password: Bcrypt.hash_pwd_salt("valid password")
    }
  end

  def build(:organization) do
    %Organization{
      name: unique("Team")
    }
  end

  def build(:organization_member) do
    user = build(:user)

    %OrganizationMember{
      name: user.name,
      email: user.email,
      user: user,
      organization: build(:organization)
    }
  end

  def build(:team) do
    %Team{
      name: unique("Team"),
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
      name: unique("Standup Member"),
      standup: build(:standup)
    }
  end

  def build(:vacation) do
    team_member = create(:team_member)

    %Vacation{
      team_member: team_member,
      team: team_member.team,
      starts_at: naive_now(),
      ends_at: naive_now(),
      type: "all day"
    }
  end

  def build(:sticky_lane) do
    %StickyLane{
      team: build(:team),
      name: unique("Sticky Lane"),
      position: 1
    }
  end

  def build(:sticky) do
    sticky_lane = create(:sticky_lane)

    %Sticky{
      sticky_lane: sticky_lane,
      team_id: sticky_lane.team_id,
      content: "Some note",
      position: 1,
      completed: false,
      color: "yellow"
    }
  end

  ## API
  #
  def build(factory_name, attrs),
    do: factory_name |> build() |> struct(attrs)

  def create(factory_name, attrs \\ []),
    do: build(factory_name, attrs) |> Repo.insert!()

  defp unique, do: System.unique_integer()
  defp unique(string) when is_binary(string), do: "#{string} #{unique()}"
  defp unique_user(name, domain) do
    int = unique()
    name = 
    email_user =
      name
      |> String.downcase()
      |> String.replace(" ", "")

    {"#{name} #{int}", "#{email_user}#{int}@#{domain}"}
  end
  defp naive_now(), do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
end
