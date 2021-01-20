defmodule Lemonade.TeamBoardTest do
  use Lemonade.DataCase

  alias Lemonade.TeamBoard
  alias Lemonade.Organizations

  setup do
    user = create(:user)

    attrs = %{
      "name" => "Planet Express",
      "teams" => [
        %{
          "name" => "Delivery Team"
        }
      ]
    }

    user = Lemonade.Accounts.get_user_by_email(user.email)

    Organizations.bootstrap_organization(user, attrs)

    {:ok, team} = TeamBoard.load_board(user)

    %{user: user, team: team}
  end
end
