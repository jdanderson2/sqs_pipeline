defmodule Gtube.ProducerConsumber do
  use GenStage

# The Client API

  def start_link(name_of_pipeline) do
    process_name = Enum.join([name_of_pipeline, "ProducerConsumer"], "")
    GenStage.start_link(__MODULE__, name_of_pipeline, name: String.to_atom(process_name))
  end

# The Server Callbacks

  def init(pipeline_name) do
    {:producer_consumer, name_of_pipeline, subscribe_to: [{SQS.Producer, min_demand: 0, max_demand: 1}]}
  end

  def handle_events([events] = events, _from, name_of_pipeline) do
    IO.puts "#{name_of_pipeline} ProducerConsumer received #{length events} events"
    
# Retrieve file from S3

    {_status, %{body: zipped_file}} = ExAws.S3.get_object(event.bucket, event.key)
    |> ExAws.request

    file = :zlib.gunzip(zipped_file)

    IO.puts "#{name_of_pipeline} ProducerConsumer downloaded #{event.key}"
    
# Pass the contents of that file to the consumer
    {:noreply, [Map.put(event, :file, file)], name_of_pipeline}
  end
end
