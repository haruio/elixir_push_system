defmodule PushManager.PublishSystem.Provider.GcmSender do
  use ExActor.GenServer

  alias PushManager.PublishSystem.Feedback.FeedbackDispatcher

  defstart start_link(_), do: initial_state(0)

  defcall publish({options, payload, deviceTokens}), state: state do
    {:ok, gcm_res} = GCM.push(options.gcm.api_key, deviceTokens, build_payload(payload))
    {:ok, parsed_body} = Poison.Parser.parse(gcm_res.body)

    get_changed_tokens(parsed_body, deviceTokens)
    |> FeedbackDispatcher.dispatch(options.feedback)

    reply :ok
  end

  defp get_changed_tokens(parsed_body, old_tokens) do
    get_changed_tokens(parsed_body["results"], old_tokens, [], [])
  end

  defp build_payload(payload) do
    %{
      notification: payload.message,
      data: payload.extra
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
