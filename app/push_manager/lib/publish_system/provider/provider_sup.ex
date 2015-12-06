defmodule PushManager.PublishSystem.Provider do
  use Supervisor

  alias PushManager.PublishSystem.Provider.GcmSenderPool
  alias PushManager.PublishSystem.Provider.ApnsSenderPool

  ## Public API
  def start_link(_) do
    Supervisor.start_link __MODULE__, []
  end

  ## Private API
  def init(_) do
    chilren = [
      worker(GcmSenderPool, []),
      worker(ApnsSenderPool, [])
    ]

    supervise(chilren, strategy: :one_for_one)
  end
end
