defmodule BigBrotherWeb.PageController do
  use BigBrotherWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def dependencies(conn, %{"repo" => repo, "branch" => branch}) do
    json conn, BigBrother.GitHub.fetch_dependencies(repo, branch)
  end

  def dependencies(conn, _params) do
    json conn, %{}
  end
end
