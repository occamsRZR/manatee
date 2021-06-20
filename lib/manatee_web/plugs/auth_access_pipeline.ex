defmodule ManateeWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :manatee

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
