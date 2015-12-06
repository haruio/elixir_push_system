defmodule PushManager.PublishSystem.Provider.PushDispatcher do
  @gcm_max_chunk 1000
  @apns_max_chunk 1000
  @mqtt_max_chunk 1000

  alias PushManager.PublishSystem.Provider.GcmSender
  alias PushManager.PublishSystem.Provider.ApnsSender

  def dispatch(notification) do
    IO.puts "dispatch"
    Enum.group_by(notification.pushTokens, fn(token) -> token.pushType end)
    |> Map.to_list
    |> Enum.each fn({push_type, push_tokens}) ->
      case push_type do
        "GCM" -> dispatch_sender(push_type, Map.delete(notification, :pushTokens), @gcm_max_chunk,  push_tokens)
        "APNS" -> dispatch_sender(push_type, Map.delete(notification, :pushTokens), @apns_max_chunk,  push_tokens)
        # "MQTT" -> dispatch_sender(notification.serviceId, @mqtt_max_chunk, push_type, notification.payload, notification.options, push_tokens)
        _ -> IO.puts "Error!!"
      end
    end
  end

  defp dispatch_sender(push_type, notification, max_chunk_size, device_tokens) do
    device_tokens
    |> Enum.map(&(&1.pushToken))
    |> Enum.chunk(max_chunk_size, max_chunk_size, [])
    |> Enum.each fn(chunk_tokens) ->
      case push_type do
        "GCM" -> :poolboy.transaction(GcmSender, fn(worker) -> GcmSender.publish(worker, {notification, chunk_tokens}) end)
        "APNS" -> :poolboy.transaction(ApnsSender, fn(worker) -> ApnsSender.publish(worker, {notification, chunk_tokens}) end)
        _ -> IO.puts "Error!!"
      end
    end
  end

end
