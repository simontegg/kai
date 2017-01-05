defmodule Kai.Solver do 
#   use Toniq.Worker
  import Porcelain
  import CSV
  import Ecto.Query
  import Kai.Utils

  alias Porcelain.{Process, Result}
  alias Kai.{
    Conversion, 
    Food, 
    FoodPrice, 
    FoodQuantity,
    List, 
    Price, 
    Repo, 
    Requirements
  }
  
  @food_excl [:name, :edible_portion]

  @nutrients [ 
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
  
  @food_fields @food_excl ++ @nutrients
  @price_fields [:price, :quantity, :quantity_unit] 
  @conversion_fields [:each_g, :raw_to_cooked] 
  @headers @food_fields ++ @price_fields ++ @conversion_fields

  def solve(user_id, constraints) do
    constraints_file = write_constraints(constraints)
    foods_extended = get_foods_prices()
    foods_file = write_foods(foods_extended)

    # TODO: error handling
    [solution_path, levels_path] = 
      julia_command(constraints_file, foods_file) 
      |> Porcelain.shell
      |> out
      |> String.split(";")

    File.rm(constraints_file)
    File.rm(foods_file)

    solution = get_files_as_list(solution_path)
    levels = get_files_as_list(levels_path)

    File.rm(solution_path)
    File.rm(levels_path)
     
    {solution, levels}  
  end

  @spec save_list(Integer, list(map), list(map)) :: tuple
  def save_list(user, solution, foods) do
    foods_by_name = for food <- foods, into: %{}, do: {food.name, food}
      
    food_quantities = 
      solution
      |> Enum.reduce([], fn (food, acc) -> 
            food_quantity = %{
              food_price: Repo.get(FoodPrice, foods_by_name[food["name"]].id),
              quantity: String.to_integer(food["quantity"])
            }

            acc ++ [food_quantity]
          end) 
      |> Enum.map(fn (params) -> 
            %FoodQuantity{} |> FoodQuantity.changeset(params) |> Repo.insert!
          end)

    params = %{
      name: "first", 
      food_quantities: food_quantities,
      user: user 
    }

    %List{} |> List.changeset(params) |> Repo.insert

  end


  def out(result) do
    result.out
  end

  def julia_command(constraints_file, foods_file) do
    "julia web/workers/solver.jl #{constraints_file} #{foods_file}"
  end

  def get_files_as_list(path) do
    path |> File.stream! |> CSV.decode(headers: true) |> Enum.to_list
  end

  def get_foods_prices do
    get_query
    |> Repo.all
    |> merge_result 
    |> set_100g_prices
    |> aggregate_nutrients
  end

  def write_foods(foods_extended) do
    write_input(foods_extended, "foods-#{random_string(7)}.csv")
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


  # TODO: query by user, location, time
  def get_query do
    from(fp in FoodPrice,
         left_join: p in assoc(fp, :price),
         left_join: f in assoc(fp, :food),
         left_join: c in assoc(fp, :conversion),
         select: %{
           id: fp.id, 
           price: map(p, ^@price_fields),
           food: map(f, ^@food_fields),
           conversion: map(c, ^@conversion_fields)
         })
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
    Enum.map(rows, fn (t) -> flatten(t, %{}) end)
  end

  def flatten({_, v}, _) when is_nil(v), do: %{}
  def flatten(%{} = o, acc), do: Enum.reduce(o, acc, &flatten(&1, &2))
  def flatten({k, v}, acc) when is_map(v), do: flatten(v, acc)
  def flatten({k, v}, acc), do: Map.put_new(acc, k, v)

  def write_input(list, file_name) do
    headers = list |> hd |> Map.keys
    file_path = Path.join(__DIR__, file_name)
    file = File.open!(file_path, [:write, :utf8])
    
    list |> CSV.encode(headers: headers) |> Enum.each(&IO.write(file, &1))

    file_path
  end

end
