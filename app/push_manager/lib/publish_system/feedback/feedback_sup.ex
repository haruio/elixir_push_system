defmodule PushManager.PublishSystem.Feedback do
  use Supervisor

  alias PushManager.PublishSystem.Feedback.FeedbackSenderPool

  ## Public API
  def start_link(_) do
    Supervisor.start_link __MODULE__, []
  end

  ## Private API
  def init(_) do
    chilren = [
      worker(FeedbackSenderPool, [])
    ]

    supervise(chilren, strategy: :one_for_one)
  end
end
