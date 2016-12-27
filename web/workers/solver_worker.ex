defmodule Kai.SolverWorker do 
  use Toniq.Worker
  import Porcelain
  import CSV
  import Ecto.Query

  alias Porcelain.{Process, Result}
  alias Kai.{Food, FoodsPrices, Price, Repo, Requirements}

  @food_field_list [ 
    :name,
    :calories,
    :protein, 
    :folate_dfe, 
    :biotin,
    :calcium,
    :chromium,
    :copper,
    :o3_epa,
    :o3_dha,
    :o3_dpa,
    :iodine,
    :iron,
    :magnesium,
    :manganese, 
    :mercury, 
    :molybdenum, 
    :niacin_ne, 
    :pantothenic_acid, 
    :phosphorus, 
    :potassium, 
    :riboflavin, 
    :selenium, 
    :thiamin, 
    :vitamin_a_rae, 
    :vitamin_b12, 
    :vitamin_b6, 
    :vitamin_c, 
    :vit_e_a_tocopherol, 
    :vitamin_k1, 
    :zinc ]

  @price_field_list [:price, :quantity, :quantity_unit] 
  @foods_prices_field_list [:each_to_g, :raw_to_cooked, :edible_portion] 

  def perform(user_id: user_id) do
    #get user
    #construct constraints
    #get prices 
    #get foods associated with prices
  end

  def perform(constraints: constraints) do
    query = 
      from price in Price,
      join: fp in FoodsPrices, on: fp.price_id == price.id,
      join: food in Food, on: food.id == fp.food_id,
      select: [
        map(price, ^@price_field_list),
        map(food, ^@food_field_list),
        map(fp, ^@foods_prices_field_list)
      ]

    foods = Repo.all(query) |> merge_result |> set_final_prices
    #file_path = write_input(constraints)

    IO.inspect "foods"
    IO.inspect hd(foods)

  end

  def set_final_prices(rows) do
    Enum.map(rows, &set_final_price(&1)) 
  end

  def set_final_price(row) do
    Map.put_new(row, :final_price, price_per_edible_100g(row))
  end



  @doc "cents per edible 100 grams of food"
  def price_per_edible_100g(%{
    :price => price,
    :quantity => quantity,
    :quantity_unit => quantity_unit,
    :each_to_g => each_to_g,
    :edible_portion => edible_portion,
  }) when quantity_unit == "ea" do

    100
    |> Kernel./(quantity * each_to_g)
    |> Kernel.*(price) 
    |> Kernel./(edible_portion) 
    |> round
  end
  def price_per_edible_100g(%{
    :price => price,
    :quantity => quantity,
    :quantity_unit => quantity_unit,
    :edible_portion => edible_portion,
    :raw_to_cooked => raw_to_cooked
  }) do
    denominator = if quantity_unit in ["kg", "L"], do: 0.1, else: 100

    price
    |> Kernel./(quantity / denominator)
    |> Kernel./(edible_portion)
    |> Kernel./(raw_to_cooked || 1)
    |> round
  end

  def merge_result(rows) do
    for row <- rows, do: Enum.reduce(row, fn(x, acc) -> Map.merge(acc, x) end)
  end

  def write_input(list, file_name) do
    headers = list |> hd |> Map.keys
    file_path = Path.join(__DIR__, file_name)
    file = File.open!(file_path, [:write, :utf8])
    list |> CSV.encode(headers: headers) |> Enum.each(&IO.write(file, &1))

    file_path
  end

    




end

# alternative implementation is pass constraints and foods as JSON in STDIN

