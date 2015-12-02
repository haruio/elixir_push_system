defmodule NotificationApi.ServiceView do
  use NotificationApi.Web, :view

  def render("index.json", %{service: service}) do
    %{data: render_many(service, NotificationApi.ServiceView, "service.json")}
  end

  def render("show.json", %{service: service}) do
    %{data: render_one(service, NotificationApi.ServiceView, "service.json")}
  end

  def render("service.json", %{service: service}) do
    %{id: service.id,
      service_id: service.service_id}
  end
end
