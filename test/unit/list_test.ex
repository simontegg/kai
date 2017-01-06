defmodule Kai.ListTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.List

  test "converts back to item quantities" do
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

  test "converts back to raw quantities" do
    food_quantity = %{
      price: 90,
      quantity: 200,
      name: "Rice; white; polished; boiled",
      each_g: nil,
      raw_to_cooked: 3.0
    }

    converted = List.convert(food_quantity)
    
    assert converted.raw_quantity == 67
  end

  test "does not convert" do
    food_quantity = %{
      price: 90,
      quantity: 200,
      name: "Cheese; Edam; Anchor",
      each_g: nil,
      raw_to_cooked: nil
    }

    converted = List.convert(food_quantity)
    
    refute Map.has_key?(converted, :raw_quantity)
    refute Map.has_key?(converted, :item_quantity)
  end
end
