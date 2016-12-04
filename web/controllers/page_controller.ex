defmodule Kai.PageController do
  use Kai.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
