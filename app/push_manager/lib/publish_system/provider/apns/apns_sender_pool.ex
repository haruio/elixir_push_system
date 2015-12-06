defmodule PushManager.PublishSystem.Provider.ApnsSenderPool do
  use Supervisor

  alias PushManager.PublishSystem.Provider.ApnsSender
  
  # Public API
  def start_link do
    Supervisor.start_link __MODULE__, []
  end

  defp pool_config do
    [
      {:name, {:local, ApnsSender}},
      {:worker_module, ApnsSender},
      {:size, 10},
      {:max_overflow, 1000} 
    ]
  end

  # Private API
  def init(_) do
    chilren = [
      :poolboy.child_spec(ApnsSender, pool_config, [])
    ] 

    supervise chilren, strategy: :one_for_one
  end
end
