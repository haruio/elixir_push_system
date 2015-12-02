defmodule NotificationApi.UserServiceController do
  use NotificationApi.Web, :controller

  alias NotificationApi.UserService

  plug :scrub_params, "user_service" when action in [:create, :update]

  def index(conn, _params) do
    user_service = Repo.all(UserService)
    render(conn, "index.json", user_service: user_service)
  end

  # def create(conn, %{"user_service" => user_service_params}) do
  #   changeset = UserService.changeset(%UserService{}, user_service_params)

  #   case Repo.insert(changeset) do
  #     {:ok, user_service} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", user_service_path(conn, :show, user_service))
  #       |> render("show.json", user_service: user_service)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   user_service = Repo.get!(UserService, id)
  #   render(conn, "show.json", user_service: user_service)
  # end

  # def update(conn, %{"id" => id, "user_service" => user_service_params}) do
  #   user_service = Repo.get!(UserService, id)
  #   changeset = UserService.changeset(user_service, user_service_params)

  #   case Repo.update(changeset) do
  #     {:ok, user_service} ->
  #       render(conn, "show.json", user_service: user_service)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user_service = Repo.get!(UserService, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(user_service)

  #   send_resp(conn, :no_content, "")
  # end
end
