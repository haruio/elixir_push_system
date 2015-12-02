defmodule PushManager.PublishSystem.Feedback.FeedbackSender do
  use ExActor.GenServer

  defstart start_link(_), do: initial_state(0)

  defcall send_feedback({deleted_tokens, updated_tokens}, des_options) do
    spawn_link fn -> request(deleted_tokens, des_options.deleted) end
    spawn_link fn -> request(updated_tokens, des_options.updated) end

    reply :ok
  end

  defp  request(tokens, des) do
    header = %{"Content-Type" => "application/json"}
    body = Poison.encode!(tokens)

    case des.method do
      "POST" ->
        HTTPoison.post! des.url, body, header
      "PUT" ->
        HTTPoison.put! des.url, body, header
    end
  end

end
