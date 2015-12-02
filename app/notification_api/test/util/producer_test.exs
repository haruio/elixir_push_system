defmodule ProducerTest do
  use ExUnit.Case, async: true

  alias Util.Producer
  alias Util.ProducerPool

  # test "test" # do
  #   {:ok, pid} = Producer.start_link host: "127.0.0.1", port: 5672, username: "admin", password: "admin"
  #   Producer.publish(pid, {Producer.push_queue_name, Poison.encode! %{test: "test"}})
  #   assert is_pid(pid)
  # end

  test "pool" do
    {:ok, pid} = ProducerPool.start_link host: "127.0.0.1", port: 5672, username: "admin", password: "admin"
    :poolboy.transaction Producer, fn(worker) -> Producer.publish(worker, {Producer.push_queue_name, Poison.encode!(%{test: "test2"})}) end
  end
end
