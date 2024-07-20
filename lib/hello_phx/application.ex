defmodule HelloPhx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      HelloPhxWeb.Telemetry,
      HelloPhx.Repo,
      {DNSCluster, query: Application.get_env(:hello_phx, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelloPhx.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HelloPhx.Finch},
      # setup for clustering
      # {Cluster.Supervisor, [topologies, name: HelloPhx.ClusterSupervisor]},
      # Start a worker by calling: HelloPhx.Worker.start_link(arg)
      # {HelloPhx.Worker, arg},
      # Start to serve requests, typically the last entry
      HelloPhxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloPhx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloPhxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
