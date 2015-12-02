defmodule NotificationApi.TemplateController do
  use NotificationApi.Web, :controller

  alias NotificationApi.Template

  plug :scrub_params, "template" when action in [:create, :update]

  def index(conn, _params) do
    template = Repo.all(Template)
    render(conn, "index.json", template: template)
  end

  # def create(conn, %{"template" => template_params}) do
  #   changeset = Template.changeset(%Template{}, template_params)

  #   case Repo.insert(changeset) do
  #     {:ok, template} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", template_path(conn, :show, template))
  #       |> render("show.json", template: template)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   template = Repo.get!(Template, id)
  #   render(conn, "show.json", template: template)
  # end

  # def update(conn, %{"id" => id, "template" => template_params}) do
  #   template = Repo.get!(Template, id)
  #   changeset = Template.changeset(template, template_params)

  #   case Repo.update(changeset) do
  #     {:ok, template} ->
  #       render(conn, "show.json", template: template)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   template = Repo.get!(Template, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(template)

  #   send_resp(conn, :no_content, "")
  # end
end
