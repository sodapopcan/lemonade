defmodule Lemonade.Factory do
  alias Lemonade.Repo
  alias Lemonade.Accounts.User
  alias Lemonade.Organizations.Organization
  alias Lemonade.Teams.Team

  def build(:user) do
    %User{
      email: "user#{System.unique_integer()}@example.com",
      hashed_password: Bcrypt.hash_pwd_salt("valid password")
    }
  end

  def build(:organization) do
    %Organization{
      name: "Team #{System.unique_integer()}"
    }
  end

  def build(:organization, with_users: user) do
    build(:organization, %{created_by: user, owned_by: user})
  end

  def build(:team) do
    %Team{
      name: "Team #{System.unique_integer()}"
    }
  end

  ## API
  #
  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def create(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end
end
