defmodule FeedbackSenderPoolTest do
  use ExUnit.Case, async: true

  alias PushManager.PublishSystem.Feedback.FeedbackSenderPool
  alias PushManager.PublishSystem.Feedback.FeedbackDispatcher

  setup do
    feedback = %{
      deleted: %{
        method: "POST",
        url: "http://localhost:8080/devices/remove"
               },
      updated: %{
        method: "POST",
        url: "http://localhost:8080/devices/update"
      }
    }

    {:ok, feedback: feedback}
  end

  test "start link feedback_pool" do
    {:ok, pid} = FeedbackSenderPool.start_link

    assert is_pid(pid)
  end

  test "dispatch feedback", %{feedback: feedback} do
    {:ok, pid} = FeedbackSenderPool.start_link
    FeedbackDispatcher.dispatch({[], []}, feedback)
  end
end
