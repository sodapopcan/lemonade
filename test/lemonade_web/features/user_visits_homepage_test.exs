defmodule LemonadeWeb.UserVisitsHomepageTest do
  use LemonadeWeb.FeatureCase

  test "user can visit homepage", %{session: session} do
    session
    |> visit("/")
    |> assert_has(css(".title", text: "Lemonade"))
  end
end
