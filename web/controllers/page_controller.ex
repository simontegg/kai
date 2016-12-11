defmodule Kai.PageController do
  use Kai.Web, :controller

  def new(conn, params) do
    IO.inspect params 
    render(conn, "your-groceries.html")
  end

  def index(conn, _params) do
    render conn, "index.html", current_user: get_session(conn, :current_user)
  end
end
