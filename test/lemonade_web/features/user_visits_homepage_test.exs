defmodule LemonadeWeb.UserVisitsHomepageTest do
  use LemonadeWeb.FeatureCase

  test "user can visit homepage", %{session: session} do
    session
    |> visit("/")
    |> assert_has(css(".title", text: "Lemonade"))
  end

  test "registration", %{session: session} do
    session
    |> visit("/")
    |> click(link("Register"))
    |> fill_in(text_field("Email"), with: "hubert@planex.com")
    |> fill_in(text_field("Password"), with: "valid password")
    |> click(button("Register"))
    |> assert_has(css("h1", text: "Welcome"))
  end
end
