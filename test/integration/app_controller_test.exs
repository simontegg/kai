defmodule AppTest do
  use Kai.ConnCase, async: true
  use Plug.Test
  import Kai.Factory
  import Hashids
  alias Kai.{Repo, User}
  
  @salt Hashids.new(salt: System.get_env("SECRET_KEY_BASE"), 
                    min_len: 5)

  test "root URL" do
    conn = build_conn()
    response = get(conn, "/")

    # Invoke the plug
    #    conn = Kai.Router.call(conn, @opts)

    # Assert the response and status
    assert response.state == :sent
    assert response.status == 200
    assert html_response(response, 200) =~ "Enter your details"
  end

  test "creates temp user on submit details and redirects" do
    conn = build_conn()
    user_details = build(:user_details)

    response = post(conn, app_path(conn, :create), user_details)

    user = Repo.get_by(User, user_details)
    assert user
    
    user_id = Hashids.encode(@salt, user.id)
    assert redirected_to(response) == "/users/#{user_id}/lists"
  end

  #test "displays a users list" do
  #  conn = build_conn()
  #  user_details = build(:user_details)

  #  response = post(conn, app_path(conn, :create), user_details)

  #  user = Repo.get_by(User, user_details)
  #  assert user
  #  
  #  user_id = Hashids.encode(@salt, user.id)
  #  assert redirected_to(response) == "/users/#{user_id}/lists"
  #end



end
