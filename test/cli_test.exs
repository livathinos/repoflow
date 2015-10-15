defmodule CliTest do
  use ExUnit.Case

  import Repoflow.CLI, only: [
    parse_args: 1,
    sort_into_ascending_order: 1,
    convert_to_list_of_hashdicts: 1
  ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == { "user", "project", 99 }
  end

  test "shows a default count if two values are given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort events by ascending order" do
    result = sort_into_ascending_order(created_at_list(["c", "a", "b"]))
    events = for event <- result, do: event["created_at"]
    assert events == ~w{a b c}
  end

  defp created_at_list(values) do
    data = for value <- values,
      do: [{"created_at", value}, {"other_data", "xxx"}]
    convert_to_list_of_hashdicts data
  end
end
