defmodule HelloPhx do
  @moduledoc """
  HelloPhx keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # Application.get_application(__MODULE__)
  @app :hello_phx
  def app, do: @app
  def vsn, do: Application.spec(app(), :vsn)

  @doc """
  Get current run mode based on build-env info
  """
  def run_mode, do: Application.get_env(@app, :run_mode)
  def commit, do: Application.get_env(@app, :commit)

  def all_env, do: Application.get_all_env(@app)

  def priv_dir, do: :code.priv_dir(@app) |> to_string()
end
