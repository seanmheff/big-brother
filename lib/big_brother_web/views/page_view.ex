defmodule BigBrotherWeb.PageView do
  use BigBrotherWeb, :view

  def get_version(repo, branch) do
    BigBrother.Init.get_version(repo, branch)
  end

  def get_dependences_link(repo, branch) do
    "/dependencies?repo=#{repo}&branch=#{branch}"
  end
end
