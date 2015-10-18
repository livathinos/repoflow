defmodule Repoflow.CLI do
  import Repoflow.EventFormatter, only: [ print_flow: 1 ]

  @default_count 15

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(
      argv,
      switches: [ help: :boolean, token: :string],
      aliases: [h: :help]
    )

    case parse do
      { [ help: true ], _, _ }
        -> :help
      { [ access_token ], [ user, project, count ], _ }
        -> { user, project, count, access_token }
      { [ access_token ], [ user, project ], _ }
        -> { user, project, @default_count, access_token }
      { _, [ user, project, count ], _ }
        -> { user, project, count, {:token, ""} }
      { _, [ user, project ], _ }
        -> { user, project, @default_count, {:token, ""} }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: repoflow <user> <project> [ count | #{@default_count} ] [ --token=<token> ]
    """
    System.halt(0)
  end

  def process({user, project, count, access_token}) do
    Repoflow.GithubEvents.fetch(user, project, access_token)
    |> decode_response
    |> to_list_of_hashes
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> print_flow
  end

  def decode_response({ :ok, body }), do: body

  def decode_response({ :error, error }) do
      {_, message } = List.keyfind(error, "message", 0)
      IO.puts "Error fetching from Github: #{message}"
      System.halt(2)
  end

  def to_list_of_hashes(list) do
    list |> Enum.map(&Enum.into(&1, HashDict.new))
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues,
      fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
  end
end
