defmodule SQS.ConsumerSupervisor do
  use ConsumerSupervisor

  def start_link(name) do
    IO.puts "SQS.Supervisor #{name}"
    Supervisor.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def init(pipeline_name) do
    children = [
      worker(SQS.ProducerConsumer, [pipeline_name]),
      worker(SQS.Consumer, [pipeline_name])
    ]

    opts = [strategy: :one_for_one, name: "ConsumerSupervisor"]
    supervise(children, opts)
  end
end
