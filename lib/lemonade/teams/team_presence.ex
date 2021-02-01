defmodule Lemonade.Teams.TeamPresence do
  use Phoenix.Presence,
    otp_app: :lemonade,
    pubsub_server: Lemonade.PubSub

  @topic_prefix "team_presence"

  def start_tracking(pid, team_member) do
    Phoenix.PubSub.subscribe(Lemonade.PubSub, topic(team_member))
    {:ok, _} = track(pid, topic(team_member), team_member.id, %{})
  end

  def list_team_member_ids(team_member) do
    team_member
    |> topic()
    |> list()
    |> Map.keys()
  end

  defp topic(team_member) do
    "#{@topic_prefix}:#{team_member.team_id}"
  end
end
