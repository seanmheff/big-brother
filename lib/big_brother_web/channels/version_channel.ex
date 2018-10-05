defmodule BigBrotherWeb.VersionChannel do
  require Logger
  use Phoenix.Channel

  def join("version:subscribe", _message, socket) do
    Logger.debug "BigBrotherWeb.VersionChannel.join"
    {:ok, BigBrother.Init.get_all_versions, socket}
  end

  def emit(repo, branch, version) do
    Logger.debug "BigBrotherWeb.VersionChannel.emit(#{repo}, #{branch}, #{version})"
    BigBrotherWeb.Endpoint.broadcast(
      "version:subscribe",
      "publish",
      %{repo: repo, branch: branch, version: version}
    )
  end
end
