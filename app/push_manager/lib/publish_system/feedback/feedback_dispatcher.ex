defmodule PushManager.PublishSystem.Feedback.FeedbackDispatcher do

  alias PushManager.PublishSystem.Feedback.FeedbackSender
  alias PushManager.PublishSystem.Feedback.FeedbackSenderPool

  def dispatch(changed_tokens, options) do
    :poolboy.transaction(FeedbackSender, fn(worker) ->
      FeedbackSender.send_feedback(worker, changed_tokens, options)
    end)
  end
end
