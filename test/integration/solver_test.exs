defmodule Kai.SolverIntegrationTest do
  use Kai.IntegrationCase, async: true
  import Kai.Factory
  alias Kai.{FoodQuantity, List, User, Solver}

  @tag external: true
  test "executes julia solver and recieves results" do
    user = insert(:user)  
    constraints = build(:constraints)

    {solution, levels} = Solver.solve(user.id, constraints)
    food = hd(solution)
    assert food["name"] 

    IO.inspect food

    assert is_list(solution)
    assert is_list(levels)
    assert length(solution) > 0
  end


end


