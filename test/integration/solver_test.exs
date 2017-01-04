defmodule Kai.SolverIntegrationTest do
  use Kai.IntegrationCase, async: true
  import Kai.Factory
  alias Kai.{FoodQuantity, List, Solver}

  @tag external: true
  test "executes julia solver and recieves results" do
    user = insert(:user)  
    constraints = build(:constraints)

    {solution, levels} = Solver.solve(user.id, constraints)
    IO.inspect solution    
    assert is_list(solution)
    assert is_list(levels)
    assert length(solution) > 0
  end

  @tag :skip
  test "saves solution as a list associated to a user" do
    user = insert(:user)

    list = build(:list)

    IO.inspect list

    case Solver.save_list(user.id, list) do
      {:ok, saved_list} ->
        food_quantities = assoc(saved_list, :food_quantities) |> Repo.all

        assert length(food_quantities) > 0
        Enum.each(food_quantities, fn (food_quantity) ->
          assert food_quantity.food_price_id
          assert is_integer(food_quantity.quantity)
        end)
      {:error, _} ->
        flunk
    end
  end
end


