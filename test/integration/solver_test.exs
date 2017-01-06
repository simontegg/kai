defmodule Kai.SolverIntegrationTest do
  use Kai.IntegrationCase, async: true
  import Kai.Factory
  alias Kai.{Food, FoodQuantity, List, User, Solver}

  @tag external: true
  test "executes julia solver and recieves results" do
    user = insert(:user)  
    foods = Food.get_foods_prices()
    constraints = build(:constraints)

    solution = Solver.solve(user: user, 
                            foods: foods, 
                            constraints: constraints)

    IO.inspect hd(solution)
    assert is_list(solution)
    assert length(solution) > 0
  end
end


