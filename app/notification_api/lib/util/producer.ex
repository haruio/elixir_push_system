defmodule Util.Producer do
  use ExActor.GenServer

  alias AMQP

  @push_queue_name "makeus.notification.push.queue.data"
  @push_exchange_name "makeus.notification.push.exchange"

  def push_queue_name, do: @push_queue_name 
  def push_excahnge_name, do: @push_exchange_name

  defstart start_link(arg, options \\ []) do
    {:ok, pid} = AMQP.Connection.open arg
    
    initial_state(pid)
  end

  defcall publish({queue_name, data}), state: conn do
    {:ok, chan} = AMQP.Channel.open conn
    AMQP.Queue.declare chan, push_queue_name, durable: true
    AMQP.Exchange.declare chan, push_excahnge_name, :direct, durable: true
    AMQP.Queue.bind chan, push_queue_name, push_excahnge_name
    AMQP.Basic.publish chan, push_excahnge_name, "", data
    AMQP.Channel.close chan

    reply :ok
  end

end
