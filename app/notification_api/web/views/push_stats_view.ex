defmodule NotificationApi.PushStatsView do
  use NotificationApi.Web, :view

  def render("index.json", %{push_stats: push_stats}) do
    %{data: render_many(push_stats, NotificationApi.PushStatsView, "push_stats.json")}
  end

  def render("show.json", %{push_stats: push_stats}) do
    %{data: render_one(push_stats, NotificationApi.PushStatsView, "push_stats.json")}
  end

  def render("push_stats.json", %{push_stats: push_stats}) do
    %{id: push_stats.id,
      push_id: push_stats.push_id}
  end
end
