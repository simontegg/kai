defmodule Kai.ListController do
  use Kai.Web, :controller

  alias Kai.List

  def index(conn, %{"user_id" => user_id}) do
    #user = User |> Repo.get(user_id) |> Repo.preload(lists: :foods)
    lists = [
      %{
        foods: [
          %{:name => "ksksksk", test: "str"}  
        ]
      }
    ]
    
    render(conn, "index.html", lists: lists)
  end

  def show(conn, %{"list_id" => list_id}) do
    list = Repo.get!(List, list_id)
    render(conn, "show.html", list: list)
  end

end
