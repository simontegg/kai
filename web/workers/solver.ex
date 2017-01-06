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

  def solve(user: user, foods: foods, constraints: constraints) do
    constraints_file = write_constraints(constraints)
    foods = Food.get_foods_prices()
    foods_file = write_foods(foods)

    # TODO: error handling
    [solution_path, levels_path] = 
      julia_command(constraints_file, foods_file) 
      |> Porcelain.shell
      |> out
      |> String.split(";")

    File.rm(constraints_file)
    File.rm(foods_file)

    solution = get_files_as_list(solution_path)
    #TODO: use levels somehow?
    #levels = get_files_as_list(levels_path)

    File.rm(solution_path)
    File.rm(levels_path)
     
    solution  
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

  def write_foods(foods_extended) do
    write_input(foods_extended, "foods-#{random_string(7)}.csv")
  end

  def write_constraints(constraints) do
    constraints_filename = "constraints-#{random_string(7)}.csv" 

    constraints
    |> Enum.map(&reshape(&1)) 
    |> write_input(constraints_filename)
  end

  def reshape({key, value}) do
    %{nutrient: key, amount: value, constraint: "min"} 
  end

  def write_input(list, file_name) do
    headers = list |> hd |> Map.keys
    file_path = Path.join(__DIR__, file_name)
    file = File.open!(file_path, [:write, :utf8])
    
    list |> CSV.encode(headers: headers) |> Enum.each(&IO.write(file, &1))

    file_path
  end

end
