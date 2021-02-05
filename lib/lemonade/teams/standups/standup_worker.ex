defmodule Lemonade.Teams.Standups.StandupWorker do
  use GenServer
  alias Lemonade.Repo

  @interval 24 * 3_600_000
  @table :standups

  def start_link([])do
    GenServer.start_link(__MODULE__, [], name: :__standup_worker__)
  end

  defp init_table() do
    :ets.new(@table, [:bag, :public, :named_table])

    Lemonade.Teams.get_all_standups()
    |> Enum.each(&:ets.insert(@table, {&1.id}))
  end

  @impl true
  def init(init_arg) do
    init_table()

    poll()

    {:ok, init_arg}
  end

  @impl true
  def handle_info(:poll, state) do
    [{id}] = :ets.tab2list(:standups)
    standup = Repo.get_by!(Lemonade.Teams.Standups.Standup, id: id) |> Repo.preload(:standup_members)
    Lemonade.Teams.shuffle_standup(standup)

    poll()

    {:noreply, state}
  end

  def handle_info(:debug, state) do
    IO.inspect(:ets.tab2list(:standups))

    {:noreply, state}
  end

  defp poll do
    Process.send_after(self(), :poll, @interval)
  end
end
