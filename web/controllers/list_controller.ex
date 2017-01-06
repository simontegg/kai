defmodule Kai.ListController do
  use Kai.Web, :controller

  alias Kai.{FoodQuantity, List}

  def index(conn, %{"user_id" => user_id}) do
    lists = List.get_by_user_id(user_id)



    IO.inspect lists
        

    render(conn, "index.html", lists: lists)
  end

  def show(conn, %{"list_id" => list_id}) do

    render(conn, "show.html")
  end

end
