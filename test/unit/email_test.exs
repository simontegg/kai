defmodule Kai.EmailTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.Email

  @email "bernard@ww.com"
  @access_token "abc"

  test "the login email has the correct properties" do
    user = build(:user, email: @email, access_token: @access_token)

    actual_email = Email.login_email(user)

    assert actual_email.to == @email
    assert actual_email.subject == "Your token"
    assert actual_email.text_body == "Access your account http://localhost:4001/session/#{@access_token}"
  end

end
