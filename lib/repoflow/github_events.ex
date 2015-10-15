defmodule Repoflow.GithubEvents do
  @user_agent [ {"User-agent", "Elixir spyros@zendesk.com" } ]
  @github_url Application.get_env(:events, :github_url)

  def fetch(user, project) do
    events_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def events_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/events"
  end

  def handle_response({ atom, %HTTPoison.Response{status_code: code, body: body}}) do
    case code do
      200 -> { atom, :jsx.decode(body) }
      404 -> { atom, :jsx.decode(body) }
    end
  end
end
