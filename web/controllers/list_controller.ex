defmodule Kai.ListController do
  use Kai.Web, :controller

  alias Kai.{FoodQuantity, List}

  def index(conn, %{"user_id" => user_id}) do
    #user = User |> Repo.get(user_id) |> Repo.preload(lists: :foods)
    "SELECT * FROM lists
      JOIN users ON users.id = lists.user_id
      JOIN food_quantities ON lists.id = food_quantities.list_id 
      JOIN foods_prices ON foods_prices.list_id = list.id
      JOIN prices ON foods_prices.price_id = prices.id
      JOIN food ON foods_prices.food_id = food.id
      WHERE lists.id = #{user_id} "



    #
    #    lists = [
    #      %{
    #        foods: [
    #          %{:name => "ksksksk", test: "str"}  
    #        ]
    #      }
    #    ]
    
    render(conn, "index.html")
  end

  def show(conn, %{"list_id" => list_id}) do

    render(conn, "show.html")
  end

end
