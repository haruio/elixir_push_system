defmodule ConsumerSupTest do
  use ExUnit.Case, async: true

  alias PushManager.PublishSystem.ConsumerSup

  test "test" do
    {:ok, pid} = ConsumerSup.start_link [host: "127.0.0.1", port: 5672, username: "admin", password: "admin"]

    :timer.sleep 1000
  end
end
