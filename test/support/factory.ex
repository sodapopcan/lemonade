defmodule Lemonade.Factory do
  alias Lemonade.Repo
  alias Lemonade.Accounts.User
  alias Lemonade.Organizations.Organization
  alias Lemonade.Teams.Team

  def build(:user) do
    int = int()

    %User{
      name: "User #{int}",
      email: "user#{int}@example.com",
      hashed_password: Bcrypt.hash_pwd_salt("valid password")
    }
  end

  def build(:organization) do
    %Organization{
      name: "Team #{int()}"
    }
  end

  def build(:team) do
    %Team{
      name: "Team #{int()}"
    }
  end

  ## API
  #
  def build(factory_name, attrs),
    do: factory_name |> build() |> struct(attrs)

  def create(factory_name, attrs \\ []),
    do: build(factory_name, attrs) |> Repo.insert!()

  defp int, do: System.unique_integer([:positive])
end
