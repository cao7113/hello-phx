defmodule HelloPhxWeb.StatusCodeError do
  # https://hexdocs.pm/phoenix/custom_error_pages.html#custom-exceptions
  defexception code: 0, message: "unknown status code", plug_status: 404
end

defimpl Plug.Exception, for: HelloPhxWeb.StatusCodeError do
  require Logger
  def status(_exception), do: 500

  def actions(_exception) do
    [
      # %{
      #   label: "Run seeds",
      #   handler: {Code, :eval_file, ["priv/repo/seeds.exs"]}
      # }
      %{
        label: "Exception TestAction1",
        handler: {__MODULE__, :do_fix_action, []}
      }
    ]
  end

  def do_fix_action() do
    Logger.warning("mocking do exception actions...")
  end
end
