defmodule Mix.Tasks.Gen.Cookie do
  use Mix.Task

  # todo: move to ehelper
  @shortdoc "Gen random node cookie"

  @impl Mix.Task
  def run(_args) do
    Base.url_encode64(:crypto.strong_rand_bytes(40))
    |> Mix.shell().info()
  end
end
