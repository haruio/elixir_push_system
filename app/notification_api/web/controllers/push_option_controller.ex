defmodule NotificationApi.PushOptionController do
  use NotificationApi.Web, :controller

  alias NotificationApi.PushOption

  plug :scrub_params, "push_option" when action in [:create, :update]

  def index(conn, _params) do
    push_option = Repo.all(PushOption)
    render(conn, "index.json", push_option: push_option)
  end

  # def create(conn, %{"push_option" => push_option_params}) do
  #   changeset = PushOption.changeset(%PushOption{}, push_option_params)

  #   case Repo.insert(changeset) do
  #     {:ok, push_option} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", push_option_path(conn, :show, push_option))
  #       |> render("show.json", push_option: push_option)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   push_option = Repo.get!(PushOption, id)
  #   render(conn, "show.json", push_option: push_option)
  # end

  # def update(conn, %{"id" => id, "push_option" => push_option_params}) do
  #   push_option = Repo.get!(PushOption, id)
  #   changeset = PushOption.changeset(push_option, push_option_params)

  #   case Repo.update(changeset) do
  #     {:ok, push_option} ->
  #       render(conn, "show.json", push_option: push_option)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   push_option = Repo.get!(PushOption, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(push_option)

  #   send_resp(conn, :no_content, "")
  # end
end
