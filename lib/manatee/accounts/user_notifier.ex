defmodule Manatee.Accounts.UserNotifier do
  alias Manatee.Emails
  alias Manatee.Mailer

  defp deliver(%Bamboo.Email{} = email) do
    Mailer.deliver_now(email)
    {:ok, %{to: email.to, body: email.html_body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(Emails.welcome_email(%{email: user.email, url: url}))
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(Emails.reset_password_email(%{email: user.email, url: url}))
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(Emails.update_email_email(%{email: user.email, url: url}))
  end
end
