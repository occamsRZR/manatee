defmodule ManateeWeb.Live.AuthHelper do
  @moduledoc "Helpers to assist with loading the user from the session into the socket"
  @claims %{"typ" => "access"}
  @token_key "user_token"

  alias Manatee.Accounts

  def load_user(%{@token_key => token}) do
    user = Accounts.get_user_by_session_token(token)
    {:ok, user}
  end

  def load_user(_), do: {:error, :not_authorized}

  def load_user!(params) do
    case load_user(params) do
      {:ok, user} -> user
      _ -> nil
    end
  end
end
