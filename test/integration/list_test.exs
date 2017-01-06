defmodule Kai.ListIntegrationTest do
  use Kai.IntegrationCase, async: true
  import Kai.Factory
  alias Kai.{FoodQuantity, List, User, Solver}

  # TODO: decouple from Solver
  test "saves solution as a list associated to a user" do
    user = insert(:user)
    solution = build_list(3, :solution_food)
    foods = Solver.get_foods_prices()
    {_, list} = Solver.save_list(user, solution, foods)
  
    lists = List.get_by_user(user.id) 

    IO.inspect lists

    assert lists
  end
end


