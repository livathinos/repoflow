defmodule Repoflow.GithubEvents do
  @user_agent [ {"User-agent", "Elixir spyros@zendesk.com" } ]
  @github_url Application.get_env(:repoflow, :github_url)

  def fetch(user, project, access_token) do
    events_url(user, project, access_token)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def events_url(user, project, access_token) do
    base_url = "#{@github_url}/repos/#{user}/#{project}/issues/events"
    { atom, token_value } = access_token

    if String.length(token_value) > 1 do
      base_url <> "?access_token=#{token_value}"
    else
      base_url
    end
  end

  def handle_response({ atom, %HTTPoison.Response{status_code: code, body: body}}) do
    case code do
      200 -> { atom, :jsx.decode(body) }
      404 -> { atom, :jsx.decode(body) }
    end
  end
end
