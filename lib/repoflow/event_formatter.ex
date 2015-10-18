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

    IO.puts "| " <>
      IO.ANSI.yellow()  <> " #{justify(String.capitalize(event_body.event), 10, :left)}" <>
      IO.ANSI.white()   <> " #{justify("[##{event_body.number}]", 8, :left)}" <>
      IO.ANSI.reset()   <> " #{justify(event_body.title, 70, :left)}" <>
      IO.ANSI.magenta() <> " #{justify(event_body.user, 10, :right)}" <>
      IO.ANSI.reset()   <> "\n"
  end

  defp justify(string, length, align) do
    if String.length(string) > length do
      String.slice(string, 0, length - 1) <> "…"
    else
      case align do
        :left -> String.ljust(string, length)
        :right -> String.rjust(string, length)
      end
    end
  end
end
