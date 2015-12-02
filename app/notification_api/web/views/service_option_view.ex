defmodule NotificationApi.ServiceOptionView do
  use NotificationApi.Web, :view

  def render("index.json", %{service_option: service_option}) do
    %{data: render_many(service_option, NotificationApi.ServiceOptionView, "service_option.json")}
  end

  def render("show.json", %{service_option: service_option}) do
    %{data: render_one(service_option, NotificationApi.ServiceOptionView, "service_option.json")}
  end

  def render("service_option.json", %{service_option: service_option}) do
    %{id: service_option.id,
      service_id: service_option.service_id}
  end
end
