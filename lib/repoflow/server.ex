defmodule Repoflow.Server do
  use GenServer

  defstruct [:node, :data, :schedulers_snapshot,
             selected: 0, offset: 0, sort_by: :pid, sort_order: :ascending,
             paused?: false]

  def start_link(opts \\ []) do
    GenServer.start_link Repoflow.Server, opts
  end

  def init(opts) do
    GenServer.cast self, :render
  end
end
