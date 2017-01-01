defmodule Kai.SessionController do
  use Kai.Web, :controller
  alias Kai.{Mailer, Auth, User, Email}

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> %User{email: email}
      user -> user
    end
  end
  
  def create(conn, %{"user" => user_params}) do
    user_struct = 
      user_params["email"]
      |> String.downcase
      |> user_by_email 
      |> User.registration_changeset(user_params)

    case Repo.insert_or_update(user_struct) do
      {:ok, user} ->
        Task.async(fn -> 
          user |> Email.login_email |> Mailer.deliver_now 
        end)

        conn
        |> put_flash(:info, gettext("sent link"))
        |> redirect(to: app_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => access_token}) do
    case Repo.get_by(User, access_token: access_token) do
      nil ->
        conn
        |> put_flash(:error, gettext("Access token not found or expired."))
        |> redirect(to: app_path(conn, :index))

      user ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, gettext("Welcome %{email}", email: user.email))
        |> redirect(to: app_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> put_flash(:info, gettext "User logged out.")
    |> redirect(to: app_path(conn, :index))
  end
end

