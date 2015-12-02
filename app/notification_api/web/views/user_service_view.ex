defmodule NotificationApi.UserServiceView do
  use NotificationApi.Web, :view

  def render("index.json", %{user_service: user_service}) do
    %{data: render_many(user_service, NotificationApi.UserServiceView, "user_service.json")}
  end

  def render("show.json", %{user_service: user_service}) do
    %{data: render_one(user_service, NotificationApi.UserServiceView, "user_service.json")}
  end

  def render("user_service.json", %{user_service: user_service}) do
    %{id: user_service.id,
      user_seq: user_service.user_seq}
  end
end
