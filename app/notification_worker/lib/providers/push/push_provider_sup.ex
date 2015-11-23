defmodule NotificationWorker.Provider.PushProviderSup do
  use Supervisor

  def start_link(options) do
    Supervisor.start_link(__MODULE__, options)
  end

  # intenal API
  def init(options) do
    children = [
      worker(NotificationWorker.Provider.PushSenderSup, [options])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
