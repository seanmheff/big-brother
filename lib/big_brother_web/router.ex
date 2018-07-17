defmodule BigBrotherWeb.Router do
  use BigBrotherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BigBrotherWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/github", BigBrotherWeb do
    pipe_through :api

    post "/", GitHubController, :receive_webhook
  end
end
