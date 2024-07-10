defmodule HelloPhxWeb.StatusController do
  use HelloPhxWeb, :controller

  ## Copied from Plug.Conn.Status
  # https://hexdocs.pm/plug/Plug.Conn.Status.html#code/1-known-status-codes
  @statuses %{
    100 => "Continue",
    101 => "Switching Protocols",
    102 => "Processing",
    103 => "Early Hints",
    200 => "OK",
    201 => "Created",
    202 => "Accepted",
    203 => "Non-Authoritative Information",
    204 => "No Content",
    205 => "Reset Content",
    206 => "Partial Content",
    207 => "Multi-Status",
    208 => "Already Reported",
    226 => "IM Used",
    300 => "Multiple Choices",
    301 => "Moved Permanently",
    302 => "Found",
    303 => "See Other",
    304 => "Not Modified",
    305 => "Use Proxy",
    306 => "Switch Proxy",
    307 => "Temporary Redirect",
    308 => "Permanent Redirect",
    400 => "Bad Request",
    401 => "Unauthorized",
    402 => "Payment Required",
    403 => "Forbidden",
    404 => "Not Found",
    405 => "Method Not Allowed",
    406 => "Not Acceptable",
    407 => "Proxy Authentication Required",
    408 => "Request Timeout",
    409 => "Conflict",
    410 => "Gone",
    411 => "Length Required",
    412 => "Precondition Failed",
    413 => "Request Entity Too Large",
    414 => "Request-URI Too Long",
    415 => "Unsupported Media Type",
    416 => "Requested Range Not Satisfiable",
    417 => "Expectation Failed",
    418 => "I'm a teapot",
    421 => "Misdirected Request",
    422 => "Unprocessable Entity",
    423 => "Locked",
    424 => "Failed Dependency",
    425 => "Too Early",
    426 => "Upgrade Required",
    428 => "Precondition Required",
    429 => "Too Many Requests",
    431 => "Request Header Fields Too Large",
    451 => "Unavailable For Legal Reasons",
    500 => "Internal Server Error",
    501 => "Not Implemented",
    502 => "Bad Gateway",
    503 => "Service Unavailable",
    504 => "Gateway Timeout",
    505 => "HTTP Version Not Supported",
    506 => "Variant Also Negotiates",
    507 => "Insufficient Storage",
    508 => "Loop Detected",
    510 => "Not Extended",
    511 => "Network Authentication Required"
  }

  def index(conn, _) do
    conn
    |> put_resp_content_type("text/plain")
    |> json(statuses())
  end

  def show(conn, %{} = params) do
    raw_code = params["code"]
    code = norm_status_code(raw_code)
    rcode = resp_code(code)
    phrase = phrase_reason(code)

    data = %{
      status_code: code,
      phrase: phrase,
      raw_code: raw_code,
      resp_code: rcode
    }

    conn
    |> put_status(rcode)
    |> json(data)
  end

  def norm_status_code(code_str) do
    try do
      int_code = String.to_integer(code_str)

      if int_code in codes() do
        int_code
      else
        :invalid_code
      end
    catch
      _ ->
        :invalid_code
    end
  end

  def phrase_reason(code) when is_integer(code), do: Plug.Conn.Status.reason_phrase(code)
  def phrase_reason(_code), do: "invalid code"

  def resp_code(code) when is_integer(code), do: code
  def resp_code(_code), do: 400

  def statuses, do: @statuses
  def codes, do: statuses() |> Map.keys()
  def phrase(code) when is_integer(code), do: statuses()[code]
end
