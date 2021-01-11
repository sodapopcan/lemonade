defmodule Lemonade.OrganizationsTest do
  use Lemonade.DataCase

  alias Lemonade.Organizations

  describe "organizations" do
    test "creates and organization with a name, created_by, and owned_by set" do
      user = create(:user)

      {:ok, organization} =
        Organizations.create_organization(%{name: "Planet Express", creating_user: user})

      assert %{created_by_id: user_id, owned_by_id: user_id} = organization
      assert user_id == user.id
    end
  end
end
