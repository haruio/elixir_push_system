defmodule PushManager.PublishSystem.Consumer do
  use GenServer
  use AMQP

  alias PushManager.PublishSystem.Provider.PushDispatcher

  @push_queue_name "makeus.notification.push.queue.data"
  @push_exchange_name "makeus.notification.push.exchange"

  def push_queue_name, do: @push_queue_name
  def push_excahnge_name, do: @push_exchange_name

  def start_link(args) do
    GenServer.start_link __MODULE__, args, []
  end

  def init(args) do
    {:ok, conn} = Connection.open args
    {:ok, chan} = Channel.open conn

    Basic.qos chan, prefetch_count: 1

    Queue.declare chan, push_queue_name, durable: true
    Exchange.direct chan, push_excahnge_name, durable: true
    Queue.bind chan, push_queue_name, push_excahnge_name
    {:ok, _consumer_tage} = Basic.consume chan, push_queue_name

    {:ok, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end

  defp consume(channel, tag, redelivered, payload) do

    spawn fn ->
      Poison.decode!(payload, keys: :atoms)
      |> PushDispatcher.dispatch
      Basic.ack channel, tag
    end
  end
end
