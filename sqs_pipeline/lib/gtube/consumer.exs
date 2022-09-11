defmodule Gtube.Consumer do
  use GenStage

  def start_link(_initial) do
    use GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [GTUBE.ProducerConsumer, min_demand: 0, max_demand: 10]}
  end

  def handle_events(events, _from, state) do
    :timer.sleep(1000)

    for event <- events do
      IO.puts ({self(), event, state})
    end

    # As a consumer we never emit events
    {:noreply, [], state}
  end
end
