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


  test "saves solution as a list associated to a user" do
    user = insert(:user)
    solution = build_list(3, :solution_food)
    foods = Solver.get_foods_prices()


    case Solver.save_list(user, solution, foods) do
      {:ok, list} ->
        food_quantities = Ecto.assoc(list, :food_quantities) |> Repo.all

        assert length(food_quantities) > 0
        Enum.each(food_quantities, fn (food_quantity) ->
          assert food_quantity.food_price_id
          assert is_integer(food_quantity.quantity)
        end)
      {:error, _} ->
        flunk
      _ -> 
        flunk
    end
  end
end


