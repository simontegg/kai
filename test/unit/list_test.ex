defmodule Kai.ListTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.List

  test "the login email has the correct properties" do

    food_quantity = %{
      price: 300,
      quantity: 200,
      name: "Avocado; flesh; raw; combined varieties",
      each_g: 170,
      raw_to_cooked: nil
    }

    converted = List.convert(food_quantity)
    
    assert converted.item_quantity == 1.2
  end

end
