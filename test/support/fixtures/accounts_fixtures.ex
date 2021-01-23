defmodule Lemonade.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lemonade.Accounts` context.
  """

  def valid_user_name, do: "Hubert Farnsworth"
  def unique_user_email, do: "employee-#{System.unique_integer()}@example.com"
  def valid_user_password, do: "goodnewseveryone!"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: valid_user_name(),
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> Lemonade.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
