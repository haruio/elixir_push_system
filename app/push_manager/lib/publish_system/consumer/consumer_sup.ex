defmodule PushManager.PublishSystem.ConsumerSup do
  use Supervisor

  alias PushManager.PublishSystem.Consumer

  def start_link(args) do
    Supervisor.start_link __MODULE__, args
  end

  def init(args) do
    children = [
      # worker(Consumer, [args]),
      # worker(Consumer, [args]),
      # worker(Consumer, [args]),
      # worker(Consumer, [args]),
      worker(Consumer, [args])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
