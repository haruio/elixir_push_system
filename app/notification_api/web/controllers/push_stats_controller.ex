defmodule NotificationApi.PushStatsController do
  use NotificationApi.Web, :controller

  alias NotificationApi.PushStats

  plug :scrub_params, "push_stats" when action in [:create, :update]

  def index(conn, _params) do
    push_stats = Repo.all(PushStats)
    render(conn, "index.json", push_stats: push_stats)
  end

  # def create(conn, %{"push_stats" => push_stats_params}) do
  #   changeset = PushStats.changeset(%PushStats{}, push_stats_params)

  #   case Repo.insert(changeset) do
  #     {:ok, push_stats} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", push_stats_path(conn, :show, push_stats))
  #       |> render("show.json", push_stats: push_stats)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   push_stats = Repo.get!(PushStats, id)
  #   render(conn, "show.json", push_stats: push_stats)
  # end

  # def update(conn, %{"id" => id, "push_stats" => push_stats_params}) do
  #   push_stats = Repo.get!(PushStats, id)
  #   changeset = PushStats.changeset(push_stats, push_stats_params)

  #   case Repo.update(changeset) do
  #     {:ok, push_stats} ->
  #       render(conn, "show.json", push_stats: push_stats)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   push_stats = Repo.get!(PushStats, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(push_stats)

  #   send_resp(conn, :no_content, "")
  # end
end
