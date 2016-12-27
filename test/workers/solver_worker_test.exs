defmodule Kai.SolverWorkerTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.SolverWorker

  def test_file(list) do
    headers = list |> hd |> Map.keys
    
    list
    |> CSV.encode(headers: headers)
    |> Enum.reduce("", fn(line, acc) -> acc <> line end)
  end

  test "constraints written to file " do
    constraints = build(:constraints)  
    expected_file = test_file([constraints])
    
    file_path = SolverWorker.write_input([constraints], "constraints.csv")
   
    assert(file_path)
    case File.read(file_path) do
      {:ok, body} -> assert(body == expected_file)
      {:error, reason} -> flunk("no file!")
    end

    File.rm(file_path)
  end

  test "calculates final price (avocado)" do
    food_price = build(:price_conversion) 
    expected_final_price =  round((179 * (100 / 170)) / 0.66)
    final_price = SolverWorker.price_per_edible_100g(food_price)

    assert final_price == expected_final_price
  end

  test "calculates final price (dozen eggs)" do
    params = [price: 700, quantity: 12, each_to_g: 58, edible_portion: 1] 
    food_price = build(:price_conversion, params)
    expected_final_price =  round((100 / (58 * 12)) * 700)
    final_price = SolverWorker.price_per_edible_100g(food_price)

    assert final_price == expected_final_price
  end
  
  test "calculates final price (rice)" do
    params = [
      price: 289, 
      each_to_g: nil, 
      raw_to_cooked: 3, 
      quantity_unit: "kg",
      edible_portion: 1
    ] 

    food_price = build(:price_conversion, params)
    expected_final_price =  round(289 / 10 / 3 * 1)
    final_price = SolverWorker.price_per_edible_100g(food_price)

    assert final_price == expected_final_price
  end
  
  test "calculates final price (spinach)" do
    params = [
      price: 399, 
      quantity: 400,
      each_to_g: nil, 
      quantity_unit: "g",
      edible_portion: 0.8692
    ] 

    food_price = build(:price_conversion, params)
    expected_final_price =  round((399 / (400 / 100)) / 0.8692)
    final_price = SolverWorker.price_per_edible_100g(food_price)

    assert final_price == expected_final_price
  end

end
