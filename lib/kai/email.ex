defmodule Kai.Email do
  alias Kai.{Endpoint, Router, User}
  import Bamboo.Email

  def login_email(%User{email: email, access_token: token}) do
    new_email
    |> to(email)
    |> from("me@example.com")
    |> subject("Your token")
    |> text_body("Access your account #{token_url(token)}")
  end

  defp token_url(token) do
    Router.Helpers.session_url(Endpoint, :show, token)
  end
  
  def welcome_email do
  end
end
