defmodule PushManager.PublishSystem do
  use Supervisor

  alias PushManager.PublishSystem.Feedback
  alias PushManager.PublishSystem.Provider
  alias PushManager.PublishSystem.ConsumerSup
  
  ## Public API
  def start_link(_) do
    Supervisor.start_link __MODULE__, [] 
  end

  ## Private API
  def init(_) do
    chilren = [
      worker(Feedback, [[]]),
      worker(Provider, [[]]),
      worker(ConsumerSup, [[host: "127.0.0.1", port: 5672, username: "admin", password: "admin"]])
    ]

    supervise(chilren, strategy: :one_for_one)
  end
end
