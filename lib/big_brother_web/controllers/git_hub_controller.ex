defmodule BigBrotherWeb.GitHubController do
  use BigBrotherWeb, :controller

  def receive_webhook(conn, %{ "repository" => %{ "name" => repo }, "ref" => "refs/heads/" <> branch }) do
    # We get notifications for all branches. Check if we care about this notification
    if BigBrother.Init.is_monitored_branch?(repo, branch) do
      BigBrother.Init.fetch_update(repo, branch)
    end

    send_resp(conn, 200, "")
  end

  def receive_webhook(conn, _) do
    send_resp(conn, 200, "")
  end
end
