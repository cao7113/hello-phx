defmodule Mix.Tasks.Commit do
  use Mix.Task

  @shortdoc "Get git commit info"
  @requirements ["app.start"]

  @impl Mix.Task
  def run(_args) do
    HelloPhx.commit()
    |> inspect(pretty: true, width: 80)
    |> Mix.shell().info
  end
end
