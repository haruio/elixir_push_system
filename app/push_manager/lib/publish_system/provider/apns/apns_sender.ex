defmodule PushManager.PublishSystem.Provider.ApnsSender do
  use ExActor.GenServer

  alias PushManager.Model.PushStats.Query, as: PushStatsQuery
  alias APNS

  defstart start_link(_), do: initial_state(0)

  def pool_name, do: :app_dev_pool

  defcall publish({notification, deviceTokens}), state: state do
    message = build_payload(notification)
    deviceTokens
    |> Enum.each(fn(token) ->
      m = message |> Map.put :token, token
      APNS.push pool_name, m
    end)

    PushStatsQuery.insert_published notification.push_id, length(deviceTokens)

    reply :ok
  end

  def build_payload(%{payload: payload}) do
    APNS.Message.new
    |> Map.put(:alert, payload.message.body)
    |> Map.put(:badge, 1)
    |> Map.put(:extra, payload.extra)
  end

end
