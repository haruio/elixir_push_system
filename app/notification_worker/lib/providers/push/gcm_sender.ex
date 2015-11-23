defmodule NotificationWorker.Provider.GCMSender do
  use ExActor.GenServer
  alias NotificationWorker.Provider.FeedbackSender

  defstart start_link(options) do
    initial_state(options)
  end

  defcall publish(notification), state: options do
    option = options.gcm_options
    {:ok, body} = GCM.push(option.api_key,  notification.deviceTokens, build_payload(notification))
    {:ok, parsed_body} = Poison.Parser.parse(body.body)

    get_changed_tokens(parsed_body, notification.deviceTokens)
    |> FeedbackSender.send_feedback(option.feedback)

    reply(%{
          success: parsed_body["success"],
          failure: parsed_body["failure"]
      })
  end

  defp get_changed_tokens(parsed_body, old_tokens) do
    get_changed_tokens(parsed_body["results"], old_tokens, [], [])
  end

  defp build_payload(notification) do
    %{
      notification: notification.payload.message,
      data: notification.payload.extra
    }
  end

  defp get_changed_tokens([], [], deleted_tokens, updated_tokens), do: {deleted_tokens, updated_tokens}

  defp get_changed_tokens([changed_h | changed_t], [old_h | old_t], deleted_tokens, updated_tokens) do
    case(changed_h) do
      %{"error" => "InvalidRegistration"} ->
        deleted_tokens = deleted_tokens ++ [old_h]
      %{"error" => "NotRegistered"} ->
        deleted_tokens = deleted_tokens ++ [old_h]
      %{"message_id" => _, "registration_id" =>  updated_token} ->
        updated_tokens = updated_tokens ++ [ %{from: old_h, to: updated_token} ]
      _ ->
    end

    get_changed_tokens(changed_t, old_t, deleted_tokens, updated_tokens)
  end
end
