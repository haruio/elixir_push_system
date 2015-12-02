defmodule PushManager.PublishSystem.Feedback.FeedbackSenderPool do
  use Supervisor

  alias PushManager.PublishSystem.Feedback.FeedbackSender
  
  # Public API
  def start_link do
    Supervisor.start_link __MODULE__, []
  end

  defp pool_config do
    [
      {:name, {:local, FeedbackSender}},
      {:worker_module, FeedbackSender},
      {:size, 2},
      {:max_overflow, 10} 
    ]
  end

  # Private API
  def init(_) do
    children = [
      :poolboy.child_spec(FeedbackSender, pool_config, [])
    ] 

    supervise children, strategy: :one_for_one
  end
end
