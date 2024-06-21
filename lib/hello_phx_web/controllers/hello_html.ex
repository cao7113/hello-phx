defmodule HelloPhxWeb.HelloHTML do
  @moduledoc """
  This module contains pages rendered by HelloController.

  See the `hello_html` directory for all templates available.
  """
  use HelloPhxWeb, :html

  embed_templates("hello_html/*")

  def fun_component(assigns) do
    ~H"""
    Hello from simple view function component!
    """
  end
end
