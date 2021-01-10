defmodule Lemonade.Factory do
  alias Lemonade.Repo
  alias Lemonade.Accounts.User

  def build(:user) do
    %User{
      email: "user#{System.unique_integer()}@example.com",
      hashed_password: Bcrypt.hash_pwd_salt("valid password")
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
