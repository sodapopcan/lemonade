defmodule LemonadeWeb.UserVisitsHomepageTest do
  use LemonadeWeb.FeatureCase, async: true

  test "user can visit homepage", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.css(".title", text: "Welcome to Lemonade!"))
  end
end
