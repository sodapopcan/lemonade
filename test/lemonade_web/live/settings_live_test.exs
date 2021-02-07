defmodule LemonadeWeb.SettingsLiveTest do
  use LemonadeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lemonade.OrganizationsFixtures
  import Lemonade.AccountsFixtures

  alias Lemonade.Accounts

  setup :register_and_log_in_user

  setup %{user: user} do
    bootstrapped_organization_fixture(user)
  end

  @path "/settings/account"

  describe "GET settings/account" do
    test "renders settings page", %{conn: conn} do
      {:ok, view, _html} = live(conn, @path)

      assert render(view) =~ "id=\"user-settings-form\""
    end

#     test "redirects if user is not logged in" do
#       {:ok, view, _html} = live(conn, "/user-settings")
#       conn = get(conn, Routes.user_settings_path(conn, :edit))
#       assert redirected_to(conn) == Routes.user_session_path(conn, :new)
#     end
  end

  describe "Change email form" do
    @tag :capture_log
    test "updates the user email", %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, @path)

      html =
        view
        |> form("#user-settings-form", %{
          user: %{email: "newemail@planetexpress.com"},
          current_password: valid_user_password()
        })
        |> render_submit()

      assert html =~ "A link to confirm your email"
      assert Lemonade.Accounts.get_user_by_email(user.email)
    end

    test "does not update email on invalid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, @path)

      html =
        view
        |> form("#user-settings-form", %{
          user: %{email: "with spaces"},
          current_password: "invalid"
        })
        |> render_submit()

      assert html =~ "id=\"user-settings-form\""
      assert html =~ "must have the @ sign and no spaces"
      assert html =~ "is not valid"
    end
  end

  describe "Change password form" do
    test "updates the user password and resets tokens", %{conn: conn, user: user} do
      new_password_conn =
        put(conn, Routes.user_settings_path(conn, :update), %{
          "action" => "update_password",
          "current_password" => valid_user_password(),
          "user" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) == Routes.settings_path(conn, :account)
      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)
      assert get_flash(new_password_conn, :info) =~ "Password updated successfully"
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, Routes.user_settings_path(conn, :update), %{
          "action" => "update_password",
          "current_password" => "invalid",
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert redirected_to(old_password_conn) == Routes.settings_path(conn, :account)
      conn = get(recycle(old_password_conn), Routes.settings_path(conn, :account))
      response = html_response(conn, 200)
      assert response =~ "<form action=\"/user/settings\""
      assert response =~ "Something went wrong"
      # assert response =~ "should be at least 12 character(s)"
      # assert response =~ "does not match password"
      # assert response =~ "is not valid"

      assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
  end
    end

end
