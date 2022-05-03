defmodule PL.Repo do
  use Ecto.Repo,
    otp_app: :personal_logger,
    adapter: Ecto.Adapters.Postgres
end
