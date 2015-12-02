defmodule NotificationApi.PushController do
  use NotificationApi.Web, :controller
  use Timex

  alias NotificationApi.Push
  alias Util.Producer
  alias Util.KeyGenerator

  plug :scrub_params, "push" when action in [:create, :update]

  def index(conn, _params) do
    push_option = Repo.all(Push)
    render(conn, "index.json", push_option: push_option)
  end

  def send_push(conn, params) do
    service_id = get_req_header(conn, "notification-rest-token")
    |> get_service_id

    push_id = create_push_id(service_id)
    options = get_options(service_id)

    params = Dict.merge params, %{"push_id" => push_id, "service_id" =>  service_id, "push_status"=>"APR", "options" => options}

    params
    |> save_push

    params
    |> build_notification_job
    |> publish_push

    json conn, %{pushId: push_id}
  end

  defp get_service_id(token) do
    "0J.6W4i.0O6i.T"
  end

  defp get_options(service_id) do
   %{
     gcm: %{ api_key: "AIzaSyBblgLAZHvvhM6gk3ZWcl7-mYQiuStsB40" },
     apns: nil,
     service_id: service_id,
     feedback: %{
       deleted: %{
         method: "POST",
         url: "http://localhost:8080/devices/remove"
                },
       updated: %{
         method: "POST",
         url: "http://localhost:8080/devices/update"
       }
     }
   }
  end

  defp create_service_id(user_seq) do
    KeyGenerator.gen_timebased_key <> "." <> KeyGenerator.int_to_random_62_string(user_seq)
  end

  defp create_push_id(service_id) do
    :random.seed :os.timestamp
    [ service_id, KeyGenerator.gen_timebased_key, Enum.take_random(?a..?z, 5) ]
    |> Enum.join "-"
  end

  defp save_push(params) do
    changeset = Push.changeset(%Push{}, params)
    case Repo.insert(changeset) do
      {:ok, push} -> IO.puts "ok : #{inspect push}"
      {:error, changeset} -> IO.puts "error : #{inspect changeset}"
    end

  end

  defp build_notification_job(params) do
    %{
      serviceId: Dict.get(params, "service_id"),
      pushId: Dict.get(params, "push_id"),
      pushTokens: Dict.get(params, "pushTokens"),
      options: Dict.get(params, "options"),
      payload: %{
        message: Dict.get(params, "message"),
        extra: Dict.get(params, "extra")
      }
    }
  end

  defp publish_push(params) do
    :poolboy.transaction Producer, fn(worker) -> Producer.publish(worker, {Producer.push_queue_name, Poison.encode!(params)}) end
  end


  #   def create(conn, %{"push" => push_params}) do
  #     changeset = Push.changeset(%Push{}, push_params)

  #     case Repo.insert(changeset) do
  #       {:ok, push} ->
  #         conn
  #         |> put_status(:created)
  #         |> put_resp_header("location", push_path(conn, :show, push))
  #         |> render("show.json", push: push)
  #       {:error, changeset} ->
  #         conn
  #         |> put_status(:unprocessable_entity)
  #         |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #     end
  #   end

  #   def show(conn, %{"id" => id}) do
  #     push = Repo.get!(Push, id)
  #     render(conn, "show.json", push: push)
  #   end

  #   def update(conn, %{"id" => id, "push" => push_params}) do
  #     push = Repo.get!(Push, id)
  #     changeset = Push.changeset(push, push_params)

  #     case Repo.update(changeset) do
  #       {:ok, push} ->
  #         render(conn, "show.json", push: push)
  #       {:error, changeset} ->
  #         conn
  #         |> put_status(:unprocessable_entity)
  #         |> render(NotificationApi.ChangesetView, "error.json", changeset: changeset)
  #     end
  #   end

  #   def delete(conn, %{"id" => id}) do
  #     push = Repo.get!(Push, id)

  #     # Here we use delete! (with a bang) because we expect
  #     # it to always work (and if it does not, it will raise).
  #     Repo.delete!(push)

  #     send_resp(conn, :no_content, "")
  #   end
end

defmodule Util.KeyGenerator do
  use Timex
  @base_alpha [
    "ETczP5tj68NhoMwxpmuZSv0OFgY3VnJi1beIsBHLRKyqlfkWd4aD7UGCArQ9X2",
    "HFK3h1otaQlRzbwOvnqUxIfJ6yecZGVgLT4k9DSiMPCjANdXmY52Wrs0Ep8B7u",
    "h15Nlg6KFfuAyH3BtzTq0awnrsLDPdYImSxp7c2RX89oWGeEJQVjbvkUOZ4CMi",
    "XmTiCxsHUIWD49Ln6ak8G7eObhpgquBREtjMF1ASydo0YQ2fz3PvlV5NJZrKwc",
    "fnqSdkITMmLC5UQOFhYaNB2GEJoeDWiZxb8Xzrts3VARw06cgK4ypu7jPHl19v",
    "mnVQ7hAKHUT0iOklD3LJ5Cgb4GtxpZXc6r2Iaw9o8EMBqfyFWjzevSdsRYP1uN",
    "h15Nlg6KFfuAyH3BtzTq0awnrsLDPdYImSxp7c2RX89oWGeEJQVjbvkUOZ4CMi",
    "ETczP5tj68NhoMwxpmuZSv0OFgY3VnJi1beIsBHLRKyqlfkWd4aD7UGCArQ9X2",
    "XmTiCxsHUIWD49Ln6ak8G7eObhpgquBREtjMF1ASydo0YQ2fz3PvlV5NJZrKwc",
    "HFK3h1otaQlRzbwOvnqUxIfJ6yecZGVgLT4k9DSiMPCjANdXmY52Wrs0Ep8B7u",
    "XmTiCxsHUIWD49Ln6ak8G7eObhpgquBREtjMF1ASydo0YQ2fz3PvlV5NJZrKwc"
  ]
  @base_alpha_length 62

  def gen_timebased_key do
    Date.universal
    |> Date.to_timestamp
    |> Tuple.to_list
    |> Enum.map_join ".", &(int_to_random_62_string(&1))
  end

  def int_to_random_62_string(val) do
    r_int_to_random_62_string(val, @base_alpha, "")
  end

  defp r_int_to_random_62_string(0, _, key), do: key

  defp r_int_to_random_62_string(val, [h | t], key) do
    r_int_to_random_62_string(div(val, @base_alpha_length), t, key <> String.at(h, rem(val, @base_alpha_length)))
  end


  def int_to_random_62_string_fixed(val) do
    r_int_to_random_62_string_fixed(val, @base_alpha, "")
  end

  defp r_int_to_random_62_string_fixed(_, [], key), do: key
  defp r_int_to_random_62_string_fixed(val, [h | t], key) do
    r_int_to_random_62_string_fixed(div(val, @base_alpha_length), t, key <> String.at(h, rem(val, @base_alpha_length)))
  end

end
