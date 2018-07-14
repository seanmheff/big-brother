defmodule BigBrotherWeb.PageView do
  use BigBrotherWeb, :view

  def get_version(repo, branch) do
    BigBrother.State.get_version(repo, branch)
  end
end
