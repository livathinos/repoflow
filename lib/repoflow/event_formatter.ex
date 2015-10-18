defmodule Repoflow.EventFormatter do
  def print_flow(rows) do
    mapped_events = map_events(rows)

    Enum.each(mapped_events, fn(event) -> print_event(event) end)
  end

  def map_events(rows) do
    Enum.reduce rows, %{}, fn row, history ->
      issue_hash = Enum.into(row["issue"], HashDict.new)
      actor_hash = Enum.into(row["actor"], HashDict.new)

      Dict.put(history, row["id"],
        %{
          event: row["event"],
          number: issue_hash["number"],
          title: issue_hash["title"],
          user: actor_hash["login"],
          url: issue_hash["html_url"],
        }
      )
    end
  end

  def print_event(event) do
    {id, event_body} = event

    IO.puts IO.ANSI.yellow() <> "[#{String.capitalize(event_body.event)}]" <>
      IO.ANSI.white() <> " [##{event_body.number}]" <>
      IO.ANSI.reset() <>" #{event_body.title} by #{event_body.user}\n"
  end
end
