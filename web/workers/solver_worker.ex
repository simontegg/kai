defmodule Kai.SolverWorker do 
#   use Toniq.Worker
  import Porcelain
  import CSV
  import Ecto.Query
  import Kai.Utils

  alias Porcelain.{Process, Result}
  alias Kai.{Conversion, Food, FoodsPrices, Price, Repo, Requirements}

  @food_field_list [ 
    :name,
    :edible_portion,
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
    :zinc 
  ]

  @price_field_list [:price, :quantity, :quantity_unit] 
  @conversion_field_list [:each_g, :raw_to_cooked] 
  @headers @food_field_list ++ @price_field_list ++ @conversion_field_list

  def perform(user_id: user_id) do
  end

  def perform(constraints: constraints) do


    constraints_file = write_constraints(constraints)
    foods_file = write_foods()
   
    IO.inspect constraints_file
    IO.inspect foods_file


    #    [solution_path, levels_path] = 
    result = 
      Porcelain.shell("julia web/workers/solver.jl #{constraints_file} #{foods_file}")

    IO.inspect result

    [solution_path, levels_path] = String.split(result.out, ";")

    File.rm(constraints_file)
    File.rm(foods_file)

    solution = 
      solution_path
      |> File.stream!
      |> CSV.decode(headers: true)
      |> Enum.to_list

    levels =
      levels_path
      |> File.stream!
      |> CSV.decode(headers: true)
      |> Enum.to_list
    
    File.rm(solution_path)
    File.rm(levels_path)
     
    {solution, levels}  
  end

  def write_foods do
    foods_filename = "foods-#{random_string(7)}.csv" 

    get_query
    |> Repo.all 
    |> merge_result 
    |> set_100g_prices
    |> aggregate_nutrients
    |> write_input(foods_filename)
  end

  def write_constraints(constraints) do
    constraints_filename = "constraints-#{random_string(7)}.csv" 

    constraints
    |> Enum.map(&reshape(&1)) 
    |> write_input(constraints_filename)
  end



  def aggregate_nutrients(rows) do
    for row <- rows,
      do: Enum.reduce(row, %{}, &aggregate_o3_epa_dha_dpa(&1, &2))
  end
    
  def aggregate_o3_epa_dha_dpa({key, value}, acc) do
    if Enum.member?([:o3_epa, :o3_dha, :o3_dpa], key) do
      Map.update(acc, :o3_epa_dha_dpa, value, &(&1 + value))
    else 
      Map.put_new(acc, key, value)
    end
  end

  def reshape({key, value}) do
    %{nutrient: key, amount: value, constraint: "min"} 
  end

  def get_query do
    price_query = from p in Price, select: map(p, ^@price_field_list)
    food_query = from f in Food, select: map(f, ^@food_field_list)
    conversion_query = 
      from c in Conversion, 
      select: map(c, ^@conversion_field_list)

    from fp in FoodsPrices,
    preload: [
      price: ^price_query, 
      food: ^food_query, 
      conversion: ^conversion_query
    ]  
  end

  def set_100g_prices(rows) do
    Enum.map(rows, &set_100g_price(&1))
  end

  def set_100g_price(row) do
    Map.put_new(row, :price_100g, price_per_edible_100g(row))
  end

  @doc "cents per edible 100 grams of food"
  def price_per_edible_100g(%{
    :price => price,
    :quantity => quantity,
    :quantity_unit => quantity_unit,
    :each_g => each_g,
    :edible_portion => edible_portion,
  }) when quantity_unit == "ea" do

    100
    |> Kernel./(quantity * each_g)
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
    |> Kernel./(edible_portion || 1)
    |> Kernel./(raw_to_cooked || 1)
    |> round
  end
  def price_per_edible_100g(%{
    :price => price,
    :quantity => quantity,
    :quantity_unit => quantity_unit,
    :edible_portion => edible_portion,
  }) do
    denominator = if quantity_unit in ["kg", "L"], do: 0.1, else: 100

    price
    |> Kernel./(quantity / denominator)
    |> Kernel./(edible_portion || 1)
    |> round
  end

  def merge_result(rows) do
    Enum.map(rows, &filter_merge(&1))
  end

  def filter_merge(row) do
    row
    |> Map.take([:price, :food, :conversion])
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.reduce(fn (x, acc) -> Map.merge(acc, x) end)
  end

  def write_input(list, file_name) do
    headers = list |> hd |> Map.keys
    file_path = Path.join(__DIR__, file_name)
    file = File.open!(file_path, [:write, :utf8])
    
    list |> CSV.encode(headers: headers) |> Enum.each(&IO.write(file, &1))

    file_path
  end

end
