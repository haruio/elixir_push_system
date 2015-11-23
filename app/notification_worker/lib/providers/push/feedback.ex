defmodule NotificationWorker.Provider.FeedbackSender do
  def send_feedback({deleted_tokens, updated_tokens}, destination) do
    spawn fn -> request(deleted_tokens, destination.deleted) end
    spawn fn -> request(updated_tokens, destination.updated) end
  end

  defp request(body, destination) do
    header = %{"Content-Type" => "application/json"}
    body = Poison.encode!(body)

    case destination.method do
      "POST" ->
        HTTPoison.post! destination.url, body, header
      "PUT" ->
        HTTPoison.put! destination.url, body, header
    end
  end
end
