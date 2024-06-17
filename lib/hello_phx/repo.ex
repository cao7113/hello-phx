defmodule HelloPhx.Repo do
  use Ecto.Repo,
    otp_app: :hello_phx,
    adapter: Ecto.Adapters.Postgres
end
