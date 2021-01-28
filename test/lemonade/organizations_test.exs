defmodule Lemonade.OrganizationsTest do
  use Lemonade.DataCase, async: true

  describe "organizations" do
    test "prevents duplication organization names" do
      create(:organization, name: "Planet Express")

      assert_raise Ecto.ConstraintError, fn ->
        create(:organization, name: "Planet Express")
      end
    end
  end
end
