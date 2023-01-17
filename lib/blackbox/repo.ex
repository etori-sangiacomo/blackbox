defmodule Blackbox.Repo do
  use Ecto.Repo,
    otp_app: :blackbox,
    adapter: Ecto.Adapters.Postgres
end
