defmodule NotificationApi.PushController do
  use NotificationApi.Web, :controller
  use Timex

  import Ecto.Query
  
  alias NotificationApi.Push
  alias NotificationApi.Push.Query, as: PushQuery
  alias NotificationApi.Service

  alias Util.Producer
  alias Util.KeyGenerator
  alias NotificationApi.Util.QueryUtil.Paginator  
  
  @rest_token_name "notification-rest-token"

  plug :scrub_params, "push" when action in [:create, :update]

  def index(conn, _params) do
    push_option = Repo.all(Push)
    render(conn, "index.json", push_option: push_option)
  end

  def get_push_list(conn, params) do
    service = conn
    |> get_rest_token
    |> by_rest_token
    |> Repo.one

    pagination_push = service.service_id
    |> PushQuery.by_service_id
    |> PushQuery.filter(params)
    |> PushQuery.search(params)
    |> Paginator.new(params)

    pagination_push = %{pagination_push| data: pagination_push.data |> Enum.map(&(%{&1 | extra: Poison.decode!(&1.extra), push_condition: Poison.decode!(&1.push_condition)}))}

    json conn, pagination_push 
  end


  def get_push(conn, params) do
    service = conn
    |> get_rest_token
    |> by_rest_token
    |> Repo.one

    push = {service.service_id, params["id"]}
    |> PushQuery.by_service_id_and_push_id
    |> Repo.one

    push = %{push | extra: Poison.decode!(push.extra), push_condition: Poison.decode!(push.push_condition)}

    json conn, push
  end

  defp get_rest_token(conn), do: get_req_header(conn, @rest_token_name)

  def send_push(conn, params) do
    service = get_req_header(conn, "notification-rest-token")
    |> by_rest_token
    |> Repo.one

    push_id = create_push_id(service.service_id)
    options = build_options(service)

    params = Dict.merge params, %{"push_id" => push_id, "service_id" =>  service.service_id, "push_status"=>"APR", "options" => options}

    params
    |> save_push

    params
    |> build_notification_job
    |> publish_push

    json conn, %{pushId: push_id}
  end

  def by_rest_token([token]) do
    from s in Service,
    where: s.rest_token == ^token
  end


  defp build_options(service) do
   %{
     gcm: %{ api_key: service.gcm_api_key },
     apns: %{
       cert: service.apns_cert,
       key: service.apns_key
     },
     service_id: service.service_id,
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
      service_id: Dict.get(params, "service_id"),
      push_id: Dict.get(params, "push_id"),
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

end
