defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", AppWeb do
    pipe_through :api

    post "/games/:id/join", GameController, :join

    resources "/questions", QuestionController, except: [:new, :edit]
    resources "/games", GameController, except: [:edit]
    resources "/players", PlayerController, except: [:edit]
  end
end
