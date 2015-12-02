defmodule NotificationWorker.Provider.PushDispatcher do
  @gcm_max_chunk 1000
  @apns_max_chunk 1000
  @mqtt_max_chunk 1000

  alias NotificationWorker.Provider.GCMSender

  def dispatch(job) do
    Enum.group_by(job.deviceTokens, fn(token) -> token.pushType end)
    |> Map.to_list
    |> Enum.each fn({push_type, deviceTokens}) ->
      case push_type do
        "GCM" ->
          dispatch_sender(job.serviceId, @gcm_max_chunk, push_type, job.payload, deviceTokens)
        "APNS" -> dispatch_sender(job.serviceId, @apns_max_chunk, push_type, job.payload, deviceTokens) 
        "MQTT" -> dispatch_sender(job.serviceId, @mqtt_max_chunk, push_type, job.payload, deviceTokens) 
        _ -> IO.puts "Error!!"
      end
    end
  end

  defp dispatch_sender(service_id, chunk_size, push_type, payload, deviceTokens) do
    spawn_link fn ->
      deviceTokens
      |> Enum.map(&(&1.pushToken))
      |> Enum.chunk(chunk_size, chunk_size, [])
      |> Enum.each fn(chunked_tokens) ->
        # String.to_atom(service_id <> "_gcm")
        # |> :poolboy.checkout()
        # |> GCMSender.publish(%{payload: payload, deviceTokens: chunked_tokens})
        String.to_atom(service_id <> "_gcm")
        |> :poolboy.transaction(fn(worker) ->
          IO.puts "#{inspect chunked_tokens}"
          IO.puts "#{inspect payload}"
          GCMSender.publish(worker, %{payload: payload, deviceTokens: chunked_tokens})
        end)
      end
    end
  end

  defp separation_push_type(deviceTokens) do
    Enum.each(deviceTokens, fn(token) -> end)
  end


  defp lookup_sender(service_name) do
  end
end
