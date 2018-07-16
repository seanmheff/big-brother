defmodule BigBrotherWeb.PageView do
  use BigBrotherWeb, :view

  def get_version(repo, branch) do
    BigBrother.Init.get_version(repo, branch)
  end
end
