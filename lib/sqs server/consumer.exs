defmodule Gtube.Consumer do
  use GenStage

  #### Client API
  def start_link(_initial) do
    use GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #### Server Callbacks
  def init(:ok) do
    upstream = Enum.join([name: __MODULE__, "ProducerConsumer"], "")
    {:consumer, :ok, subscribe_to: [GTUBE.ProducerConsumer, min_demand: 0, max_demand: 10]}
  end


  def handle_events(events, _from, state) do
    file
    |> process_file
    |>write_output(String.split(key, "."))

    for event <- events do
      IO.puts ({self(), event, state})

      SQS.Server.release(events)

    end

    {:noreply, [], state}
  end
  
  # Private functions
  defp process_file(file) do
    file
    |> String.split("\n")
    |> Enum.filter(fn(line) -> line != "" end)
    |> Enum.count
   end
   
   defp write_output(event_count, [filepath, _]) do
    filename = filepath
    |> String.split("/")
    |> List.last
    
    # Write the count to a file in append mode
    File.open("output/#{filename}.txt", [:append], fn(file) ->
      IO.write(file, "#{event_count}\n")
    end)
  end
end
