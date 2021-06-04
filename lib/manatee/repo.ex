defmodule Manatee.Repo do
  use Ecto.Repo,
    otp_app: :manatee,
    adapter: Ecto.Adapters.Postgres
end
