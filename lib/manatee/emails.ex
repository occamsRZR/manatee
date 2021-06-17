defmodule Manatee.Emails do
  import Bamboo.Email
  use Bamboo.Phoenix, view: ManateeWeb.EmailView

  @from "noreply@manatee.valravn.us"

  def welcome_email(%{email: email, url: url}) do
    base_email()
    |> subject("Welcome!")
    |> to(email)
    |> assign(:email, email)
    |> assign(:url, url)
    |> render("welcome.html",
      title: "Thank you for signing up",
      preheader: "Thank you for signing up to the app."
    )
    |> premail()
  end

  def reset_password_email(%{email: email, url: url}) do
    base_email()
    |> subject("Reset your password")
    |> to(email)
    |> assign(:email, email)
    |> assign(:url, url)
    |> render("reset_password.html",
      title: "Reset your password",
      preheader: "Reset your password in Lawn Manatee"
    )
    |> premail()
  end

  # Called when a user wants to update their email
  def update_email_email(%{email: email, url: url}) do
    base_email()
    |> subject("Change your email")
    |> to(email)
    |> assign(:email, email)
    |> assign(:url, url)
    |> render("change_email.html",
      title: "Change your email",
      preheader: "Change your email in Lawn Manatee"
    )
    |> premail()
  end

  defp base_email do
    new_email()
    |> from(@from)
    # Set default layout
    |> put_html_layout({ManateeWeb.LayoutView, "email.html"})
    # Set default text layout
    |> put_text_layout({ManateeWeb.LayoutView, "email.text"})
  end

  defp premail(email) do
    html = Premailex.to_inline_css(email.html_body)
    text = Premailex.to_text(email.html_body)

    email
    |> html_body(html)
    |> text_body(text)
  end
end
