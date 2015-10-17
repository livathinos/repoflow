defmodule Repoflow.Server do
  use GenServer

  defstruct [:node, :data, :schedulers_snapshot,
             selected: 0, offset: 0, sort_by: :pid, sort_order: :ascending,
             paused?: false]

  def init(opts) do
    GenServer.cast self, :render
    {:ok, opts}
  end

  def handle_cast(:render, state) do
    {:noreply, state}
  end
end
