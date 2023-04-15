defmodule HelloWeb.ToolsJSON do
  def ping(%{}) do
    %{
      msg: "pong at #{DateTime.utc_now()}"
    }
  end
end
