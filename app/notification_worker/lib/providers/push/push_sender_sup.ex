defmodule NotificationWorker.Provider.PushSenderSup do
  use Supervisor

  @service_id_field :service_id 
  @gcm_suffix "_gcm"
  @apns_suffix "_apns"
  @gcm_sender NotificationWorker.Provider.GCMSender

  defp provider_pool_config(worker, service_id) do
    [
        {:name, {:local, service_id}},
        {:worker_module, worker},
        {:size, 2},
        {:max_overflow, 10} 
    ]
  end

  defp get_provider_service_name(options, suffix) do
    options[@service_id_field] <> suffix
    |> String.to_atom
  end
  
  def start_link(options) do
    Supervisor.start_link(__MODULE__, options)
  end

  # Internal API
  def init(options) do
    gcm_service_id = get_provider_service_name(options, @gcm_suffix)
    IO.puts "#{inspect gcm_service_id}"
    children = [
      :poolboy.child_spec(gcm_service_id, provider_pool_config(@gcm_sender, gcm_service_id), options)
    ]

    supervise(children, strategy: :one_for_one)
  end

end
