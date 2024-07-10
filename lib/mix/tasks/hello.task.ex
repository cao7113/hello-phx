defmodule Mix.Tasks.Hello.Task do
  use Mix.Task

  @shortdoc "Try hello task"

  @moduledoc """
  This is where we would put any long form documentation and doctests.
  """

  @requirements ["app.start"]

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info("Now I have access to Repo and other goodies!")
    Mix.shell().info("Greetings from the Hello Phoenix Application!")
  end
end
