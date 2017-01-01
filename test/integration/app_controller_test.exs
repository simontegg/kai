defmodule AppTest do
  use Kai.ConnCase, async: true
  use Plug.Test
  import Kai.Factory
  import Hashids
  alias Kai.{Repo, User}
  
  @salt Hashids.new(salt: System.get_env("SECRET_KEY_BASE"), 
                    min_len: 5)

  @tag :skip
  test "root URL" do
    # Create a test connection
    response = get(build_conn, "/")

    # Invoke the plug
    #conn = Kai.Router.call(conn, @opts)

    # Assert the response and status
    assert response.state == :sent
    assert response.status == 200
    assert html_response(response, 200) =~ "Enter your details"
  end

  test "creates temp user on submit details and redirects" do
    user_details = build(:user_details)
    user_id = Hashids.encode(@salt, 1)

    response = post(build_conn, app_path(build_conn, :create), user_details)

    assert redirected_to(response) == "/users/#{user_id}/lists"
    #    assert Repo.get_by(User, user_details)
  end




end
