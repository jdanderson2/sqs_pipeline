defmodule Gtube.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Starts a worker by calling: Gtube.Worker.start_link(arg)
      # {Gtube.Worker, arg}

      {Gtube.Producer, 0},
      {Gtube.ProducerConsumer, []},
      {Gtube.Consumer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gtube.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
