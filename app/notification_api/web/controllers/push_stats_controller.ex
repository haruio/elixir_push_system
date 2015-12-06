defmodule NotificationApi.PushStatsController do
  use NotificationApi.Web, :controller

  alias NotificationApi.PushStats
  alias NotificationApi.PushStats.Query, as: PushStatsQuery
  alias NotificationApi.PushStats.Count, as: PushCount

  alias NotificationApi.Service
  alias NotificationApi.Service.Query, as: ServiceQuery

  
  @rest_token_name "notification-rest-token"

  plug :scrub_params, "push_stats" when action in [:create, :update]

  def get_stats_summary(conn, params) do
   service = get_service(conn) 
   data = params
   |> PushStatsQuery.summary_by_push_id
   |> Repo.all
    |> Enum.reduce(%PushCount{}, fn([key|[value]], acc) ->
      case key do
        "PUB" ->
          %{acc | published: value |> Decimal.to_string |> Integer.parse |> elem(0) }
        "OPN" ->
          %{acc | opened: value |> Decimal.to_string |> Integer.parse |> elem(0) } 
        "RCV" ->
          %{acc | received: value |> Decimal.to_string |> Integer.parse |> elem(0) }
         _ ->
      end
    end)

   json conn, data 
  end

  def get_stats_timseries(conn, params) do
    service = get_service(conn) 

    json conn, %{"test" => "test"}
  end


  defp get_service(conn) do
    service = conn
    |> get_rest_token
    |> ServiceQuery.by_rest_token
    |> Repo.one
  end

  defp get_rest_token(conn), do: get_req_header(conn, @rest_token_name)
end
