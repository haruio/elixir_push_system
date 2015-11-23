defmodule NotificationApi.PageController do
  use NotificationApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
