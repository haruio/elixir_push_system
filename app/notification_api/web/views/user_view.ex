defmodule NotificationApi.UserView do
  use NotificationApi.Web, :view

  def render("index.json", %{user: user}) do
    %{data: render_many(user, NotificationApi.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, NotificationApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      user_seq: user.user_seq}
  end
end
