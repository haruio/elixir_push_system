defmodule PushJobDispatcherTest do
  use ExUnit.Case, async: true
  alias NotificationWorker.PushJobDispatcher

  test "consumer test" do
    PushJobDispatcher.start_link
  end

end
