defmodule Lemonade.Repo.Migrations.AddStartsAtAndLastShuffledAtToStandups do
  use Ecto.Migration

  def change do
    alter table(:standups) do
      add :starts_at, :time
      add :randomized, :boolean, defalut: false
      add :last_randomized_at, :naive_datetime
    end
  end
end
