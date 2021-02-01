defmodule Lemonade.Teams.TeamPresence do
  use Phoenix.Presence,
    otp_app: :lemonade,
    pubsub_server: Lemonade.PubSub

  def start_tracking(pid, team_member, subscribe) do
    subscribe.(topic(team_member))
    {:ok, _} = track(pid, topic(team_member), team_member.id, %{team_member_id: team_member.id})
  end

  def list_team_member_ids(team_member) do
    team_member
    |> topic()
    |> list()
    |> Enum.map(fn {_id, data} ->
      List.first(data[:metas])[:team_member_id]
    end)
  end

  defp topic(team_member) do
    "teams:#{team_member.team_id}"
  end
end
