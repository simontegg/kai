defmodule Kai.ListIntegrationTest do
  use Kai.IntegrationCase, async: true
  import Kai.Factory
  alias Kai.{Food, FoodQuantity, List, User, Solver}

  # TODO: decouple from List methods
  test "gets lists by user in nice format " do
    solution = build_list(3, :solution_food)
    foods = Food.get_foods_prices()
    user = insert(:user)
    {_, list} = List.save_list(solution, foods, user)

        
    lists = List.get_by_user_id(user.id) 

    lists |> hd |> Map.get(:list_id) |> Kernel.==(list.id) |> assert
  end
  
  test "saves solution as a list associated to a user" do
    solution = build_list(3, :solution_food)
    foods = Food.get_foods_prices()
    user = insert(:user)

    case List.save_list(solution, foods, user) do
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


