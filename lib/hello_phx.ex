defmodule HelloPhx do
  @moduledoc """
  HelloPhx keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @app :hello_phx

  @doc """
  Get current run mode based on build-env info
  """
  def run_mode, do: Application.get_env(@app, :run_mode)

  def all_env, do: Application.get_all_env(@app)
end
