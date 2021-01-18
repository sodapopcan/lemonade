defmodule Lemonade.TeamBoard.StandupsTest do
  use Lemonade.DataCase

  alias Lemonade.TeamBoard.Standups

  describe "standups" do
    alias Lemonade.TeamBoard.Standups.Standup

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def standup_fixture(attrs \\ %{}) do
      {:ok, standup} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Standups.create_standup()

      standup
    end

    test "list_standups/0 returns all standups" do
      standup = standup_fixture()
      assert Standups.list_standups() == [standup]
    end

    test "get_standup!/1 returns the standup with given id" do
      standup = standup_fixture()
      assert Standups.get_standup!(standup.id) == standup
    end

    test "create_standup/1 with valid data creates a standup" do
      assert {:ok, %Standup{} = standup} = Standups.create_standup(@valid_attrs)
    end

    test "create_standup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Standups.create_standup(@invalid_attrs)
    end

    test "update_standup/2 with valid data updates the standup" do
      standup = standup_fixture()
      assert {:ok, %Standup{} = standup} = Standups.update_standup(standup, @update_attrs)
    end

    test "update_standup/2 with invalid data returns error changeset" do
      standup = standup_fixture()
      assert {:error, %Ecto.Changeset{}} = Standups.update_standup(standup, @invalid_attrs)
      assert standup == Standups.get_standup!(standup.id)
    end

    test "delete_standup/1 deletes the standup" do
      standup = standup_fixture()
      assert {:ok, %Standup{}} = Standups.delete_standup(standup)
      assert_raise Ecto.NoResultsError, fn -> Standups.get_standup!(standup.id) end
    end

    test "change_standup/1 returns a standup changeset" do
      standup = standup_fixture()
      assert %Ecto.Changeset{} = Standups.change_standup(standup)
    end
  end
end
