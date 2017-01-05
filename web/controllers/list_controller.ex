defmodule Kai.ListController do
  use Kai.Web, :controller

  alias Kai.{FoodQuantity, List}

  def index(conn, %{"user_id" => user_id}) do

    render(conn, "index.html")
  end

  def show(conn, %{"list_id" => list_id}) do

    render(conn, "show.html")
  end

end
