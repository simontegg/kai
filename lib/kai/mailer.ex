defmodule Kai.Mailer do
  alias Kai.{Endpoint, Router, User}
  use Mailgun.Client,
    domain: Application.get_env(:kai, :mailgun_domain),
    key: Application.get_env(:kai, :mailgun_key)

  def send_login_token(%User{email: email, access_token: token}) do
    send_email(
      to: email,
      from: "noreplay@example.com",
      subject: "Your token",
      text: "Access your account #{token_url(token)}"
    )
  end

  defp token_url(token) do
    Router.Helpers.session_url(Endpoint, :show, token)
  end
end
