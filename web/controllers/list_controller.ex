defmodule Kai.ListController do
  use Kai.Web, :controller

  alias Kai.List

  def index(conn, _params) do
    lists = Repo.all(List)
    render(conn, "index.html", receipts: lists)
  end

  def show(conn, %{"id" => id}) do
    list = Repo.get!(List, id)
    render(conn, "show.html", list: list)
  end
end
