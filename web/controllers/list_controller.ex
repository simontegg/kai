defmodule Kai.ListController do
  use Kai.Web, :controller

  alias Kai.{FoodQuantity, List, User}
  
  def index(conn, %{"user_id" => user_id}) do
    lists = user_id |> User.decode |> List.get_by_user_id
    render(conn, "index.html", lists: lists)
  end

  def show(conn, %{"list_id" => list_id}) do

    render(conn, "show.html")
  end

end
