defmodule NotificationApi.TemplateView do
  use NotificationApi.Web, :view

  def render("index.json", %{template: template}) do
    %{data: render_many(template, NotificationApi.TemplateView, "template.json")}
  end

  def render("show.json", %{template: template}) do
    %{data: render_one(template, NotificationApi.TemplateView, "template.json")}
  end

  def render("template.json", %{template: template}) do
    %{id: template.id,
      service_id: template.service_id}
  end
end
