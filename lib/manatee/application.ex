defmodule Manatee.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Manatee.Repo,
      # Start the Telemetry supervisor
      ManateeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Manatee.PubSub},
      # Start the Endpoint (http/https)
      ManateeWeb.Endpoint
      # Start a worker by calling: Manatee.Worker.start_link(arg)
      # {Manatee.Worker, arg}
      # {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Manatee.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ManateeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Add this line
  defp oban_config do
    Application.fetch_env!(:manatee, Oban)
  end
end
