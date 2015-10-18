defmodule Repoflow.Server do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, opts
  end

  def init(opts) do
    send self, :collect
    {:ok, opts}
  end

  def handle_info(:collect, state) do
    GenServer.cast self, :render
    Repoflow.CLI.run(state)
    Process.send_after self, :collect, 60000

    {:noreply, state}
  end

  def handle_cast(:render, state) do
    {:noreply, state}
  end
end
