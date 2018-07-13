defmodule BigBrotherWeb.PageController do
  use BigBrotherWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
