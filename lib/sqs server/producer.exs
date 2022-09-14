defmodule Gtube.Producer do
  use GenStage

# The Client API
  def start_link(initial // 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end
  
  def enqueue({_count, _events} = message) do
    IO.puts "Casting events to producer"
    GenServer.cast(SQS.Producer, {:events, message})
  end

# Server callbacks
  def init(0), do: {:producer, 0}

  def handle_demand(demand, state) when demand > 0 do
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end

  def handle_cast({:events, {count, events}}, state) do
    IO.puts "SQS.Producer notified about #{count} new events"
    
    {:noreply, events, state - count}
  end

  defp take(demand) do
    IO.puts "Asking for #{demand} events"
      
    {count, events} = SQS.Server.pull(demand)
  
    IO.puts "Received #{count} events"
    {count, events}
  end
end
