defmodule Lemonade.Teams.TeamPresence do
  use Phoenix.Presence,
    otp_app: :lemonade,
    pubsub_server: Lemonade.PubSub

  def track_team_member(topic, team_member_id, data) do
    track(self(), topic, team_member_id, data)
  end

  def list_team_member_ids(topic) do
    list(topic)
      |> Enum.map(fn {_id, data} ->
        List.first(data[:metas])[:team_member_id]
      end)
  end
end
