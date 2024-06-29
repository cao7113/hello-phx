defmodule HelloPhx.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  require Logger

  @app HelloPhx.app()

  def migrate(opts \\ [all: true]) do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, opts))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def reset!(opts \\ [all: true]) do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, opts))
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, opts))
      Logger.warning("reset repo: #{inspect(repo)}")
    end

    load_seeds!()
  end

  def load_seeds!(seed_file \\ HelloPhx.priv_dir() <> "/repo/seeds.exs") do
    Code.eval_file(seed_file)
    Logger.warning("eval data seeds from: #{seed_file}")
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  # defp start_app do
  #   load_app()
  #   Application.put_env(@app, :minimal, true)
  #   Application.ensure_all_started(@app)
  # end
end
