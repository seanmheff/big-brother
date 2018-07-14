defmodule BigBrotherWeb.GitHubController do
  use BigBrotherWeb, :controller

  def receive_webhook(conn, %{ "repository" => repository, "ref" => ref }) do
    # Parse repo
    repo = repository["name"]

    # Parse branch string:
    # e.g. "refs/heads/master",
    branch = case Regex.named_captures(~r/refs\/heads\/(?<branch>.*)/, ref) do
      %{ "branch" => branch } -> branch
      _ -> nil
    end

    json conn, %{ repo: repo, branch: branch }
  end
end
