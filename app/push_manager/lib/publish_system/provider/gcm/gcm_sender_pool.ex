defmodule PushManager.PublishSystem.Provider.GcmSenderPool do
  use Supervisor

  alias PushManager.PublishSystem.Provider.GcmSender
  
  # Public API
  def start_link do
    Supervisor.start_link __MODULE__, []
  end

  defp pool_config do
    [
      {:name, {:local, GcmSender}},
      {:worker_module, GcmSender},
      {:size, 10},
      {:max_overflow, 1000} 
    ]
  end

  # Private API
  def init(_) do
    chilren = [
      :poolboy.child_spec(GcmSender, pool_config, [])
    ] 

    supervise chilren, strategy: :one_for_one
  end
end
