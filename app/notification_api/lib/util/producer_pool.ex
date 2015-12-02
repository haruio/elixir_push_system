defmodule Util.ProducerPool do
  use Supervisor

  alias Util.Producer

  def start_link(args) do
    Supervisor.start_link __MODULE__, args 
  end

  defp pool_config do
    [
      {:name, {:local, Producer}},
      {:worker_module, Producer},
      {:size, 10},
      {:max_overflow, 1000} 
    ]
  end

  # Private API
  def init(args) do
    IO.puts "Producer started #{inspect args}"
    chilren = [
      :poolboy.child_spec(Producer, pool_config, [args])
    ] 

    supervise chilren, strategy: :one_for_one
  end
end
