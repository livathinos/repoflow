defmodule Repoflow do
  def main(opts \\ []) do
    Repoflow.Server.start_link(opts)
  end
end
