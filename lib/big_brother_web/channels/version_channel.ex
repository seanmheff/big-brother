defmodule BigBrotherWeb.VersionChannel do
  use Phoenix.Channel

  def join("version:subscribe", _message, socket) do
    IO.puts "BigBrotherWeb.VersionChannel.join"
    {:ok, socket}
  end

  def emit(repo, branch, version) do
    IO.puts "BigBrotherWeb.VersionChannel.emit(#{repo}, #{branch}, #{version})"
    BigBrotherWeb.Endpoint.broadcast(
      "version:subscribe",
      "publish",
      %{repo: repo, branch: branch, version: version}
    )
  end
end
