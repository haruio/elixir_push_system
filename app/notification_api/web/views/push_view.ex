defmodule NotificationApi.PushView do
  use NotificationApi.Web, :view

  def render("index.json", %{push_option: push_option}) do
    %{data: render_many(push_option, NotificationApi.PushView, "push.json")}
  end

  def render("show.json", %{push: push}) do
    %{data: render_one(push, NotificationApi.PushView, "push.json")}
  end

  def render("push.json", %{push: push}) do
    %{id: push.id,
      push_id: push.push_id}
  end
end
