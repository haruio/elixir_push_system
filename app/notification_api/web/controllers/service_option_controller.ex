defmodule NotificationApi.ServiceOptionController do
  use NotificationApi.Web, :controller

  alias NotificationApi.ServiceOption

  plug :scrub_params, "service_option" when action in [:create, :update]

  def index(conn, _params) do
    service_option = Repo.all(ServiceOption)
    render(conn, "index.json", service_option: service_option)
  end

#   def create(conn, %{"service_option" => service_option_params}) do
#     changeset = ServiceOption.changeset(%ServiceOption{}, service_option_params)

#     case Repo.insert(changeset) do
#       {:ok, service_option} ->
#         conn
#         |> put_status(:created)
#         |> put_resp_header("location", service_option_path(conn, :show, service_option))
#         |> render("show.json", service_option: service_option)
#       {:error, changeset} ->
#         conn
#         |> put_status(:unprocessable_entity)
#         |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
#     end
#   end

#   def show(conn, %{"id" => id}) do
#     service_option = Repo.get!(ServiceOption, id)
#     render(conn, "show.json", service_option: service_option)
#   end

#   def update(conn, %{"id" => id, "service_option" => service_option_params}) do
#     service_option = Repo.get!(ServiceOption, id)
#     changeset = ServiceOption.changeset(service_option, service_option_params)

#     case Repo.update(changeset) do
#       {:ok, service_option} ->
#         render(conn, "show.json", service_option: service_option)
#       {:error, changeset} ->
#         conn
#         |> put_status(:unprocessable_entity)
#         |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
#     end
#   end

#   def delete(conn, %{"id" => id}) do
#     service_option = Repo.get!(ServiceOption, id)

#     # Here we use delete! (with a bang) because we expect
#     # it to always work (and if it does not, it will raise).
#     Repo.delete!(service_option)

#     send_resp(conn, :no_content, "")
#   end
end
