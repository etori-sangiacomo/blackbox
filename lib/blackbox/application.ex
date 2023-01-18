defmodule Blackbox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Blackbox.Repo,
      # Start the Telemetry supervisor
      BlackboxWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Blackbox.PubSub},
      # Start the Endpoint (http/https)
      BlackboxWeb.Endpoint,
      # Start a worker by calling: Blackbox.Worker.start_link(arg)
      # {Blackbox.Worker, arg}
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blackbox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BlackboxWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def oban_config do
    Application.fetch_env!(:blackbox, Oban)
  end
end
