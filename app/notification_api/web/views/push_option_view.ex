defmodule NotificationApi.PushOptionView do
  use NotificationApi.Web, :view

  def render("index.json", %{push_option: push_option}) do
    %{data: render_many(push_option, NotificationApi.PushOptionView, "push_option.json")}
  end

  def render("show.json", %{push_option: push_option}) do
    %{data: render_one(push_option, NotificationApi.PushOptionView, "push_option.json")}
  end

  def render("push_option.json", %{push_option: push_option}) do
    %{id: push_option.id,
      push_id: push_option.push_id}
  end
end
