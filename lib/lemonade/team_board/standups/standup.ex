defmodule Lemonade.TeamBoard.Standups.Standup do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "standups" do
    belongs_to :team, Lemonade.Organizations.Team

    timestamps()
  end

  @doc false
  def changeset(standup, attrs) do
    standup
    |> cast(attrs, [])
    |> validate_required([])
  end
end
