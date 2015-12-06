defmodule NotificationApi.Router do
  use NotificationApi.Web, :router

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

  scope "/", NotificationApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", NotificationApi do
    pipe_through :api

    # push
    post "/push", PushController, :send_push
    get "/push", PushController, :get_push_list
    get "/push/:id", PushController, :get_push

    # stats
    get "/stats/:push_id", PushStatsController, :get_stats_summary 
    get "/stats/:push_id/timeseries", PushStatsController, :get_stats_time_series
  end

end
