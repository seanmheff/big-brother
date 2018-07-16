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

    # Check if we care about this update
    if BigBrother.Init.is_monitored_branch?(repo, branch) do
      BigBrother.Init.fetch_update(repo, branch)
    end

    # Send <200 OK> to GitHub
    conn |> send_resp(200, "")
  end
end
