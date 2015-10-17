defmodule Repoflow do
  def main(opts \\ []) do
    { :ok, pid } = GenServer.start_link Repoflow.Server, opts

    pid
  end
end
