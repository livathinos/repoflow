defmodule Repoflow do
  use GenServer

  def main(opts \\ []) do
    __MODULE__.start_link opts
    :timer.sleep :infinity
  end

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, opts
  end

  def init(opts) do
    send self, :collect
    {:ok, opts}
  end

  def handle_info(:collect, state) do
    GenServer.cast self, :render
    Process.send_after self, :collect, 30000

    {:noreply, state}
  end

  def handle_cast(:render, state) do
    IO.write IO.ANSI.clear

    output = Repoflow.CLI.run(state)
    IO.puts(output)

    {:noreply, state}
  end
end
