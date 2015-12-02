defmodule FeedbackSenderTest do
  use ExUnit.Case, async: true

  alias PushManager.PublishSystem.Feedback.FeedbackSender

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

  test "start feedback server" do
    {:ok, pid} = FeedbackSender.start_link

    assert is_pid(pid)
  end

  test "send feedback", %{feedback: feedback} do
    {:ok, pid} = FeedbackSender.start_link

    FeedbackSender.send_feedback(pid, {[], []}, feedback)
  end
end
