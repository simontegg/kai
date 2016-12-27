defmodule Import do
  @doc "Imports nz foodfiles data to seed the database"
  def import_from_csv(csv_path, process) do
      csv_path
      |> Path.expand
      |> File.stream!
      |> CSV.decode(separator: ?,, headers: true)
      |> Stream.each(process)
      |> Stream.run
  end
end

defmodule Seeds.Food do
  alias Kai.{NutrientNameMap, Food, Repo} 

  @nzff NutrientNameMap.nzff
  @multiplier NutrientNameMap.nzff_conversion
  @fields Map.keys(@nzff)
  @non_numeric ["Food Name", "FoodID", "Chapter"]

  def process_row(row) do
    params = for {k, v} <- row,
      (Enum.member?(@fields, k)),
      into: %{}, 
      do: {Map.get(@nzff, k), convert_value(k, v)}

    %Food{}
    |> Food.changeset(params)
    |> Repo.insert!
  end

  def format_number(number, multiplier) when is_float(multiplier) do
    number|> Kernel.*(multiplier) |> Float.round(6)
  end
  def format_number(number, multiplier) do
    number * multiplier
  end

  def to_number(str) do
    {num, _} = if str =~ ".", do: Float.parse(str), else: Integer.parse(str)
      num 
  end

  def convert_value(_key, value) when value == "", do: 0
  def convert_value(key, value) when key == "FoodID", do: "nzff_" <> value
  def convert_value(key, value) when key in @non_numeric, do: value
  def convert_value(key, value) do
    number = to_number(value)

    case Map.get(@multiplier, key) do
      nil         -> number
      multiplier  -> format_number(number, multiplier)
    end
  end

end


defmodule Seeds.Price do
  alias Kai.{Conversion, Food, FoodsPrices, Price, Repo} 
  
  @integers ["price", "quantity", "each_to_g"]
  @floats ["raw_to_cooked"]

  def process_price(row) do
    price_data = for {k, v} <- row,
      into: %{},
      do: {String.to_atom(k), convert_value(k, v)}

    food = Repo.get_by(Food, name: price_data.food_name)
    price = %Price{} |> Price.changeset(price_data) |> Repo.insert!

    food_price =
      %FoodsPrices{} 
      |> FoodsPrices.changeset(%{food_id: food.id, price_id: price.id}) 
      |> Repo.insert!

    insert_conversion(
      food_price.id, 
      price_data.each_to_g, 
      price_data.raw_to_cooked
    )

  end

  def insert_conversion(food_price_id, each_to_g, raw_to_cooked) when (each_to_g or raw_to_cooked) do
    changeset = %{
      food_price_id: food_price_id,
      each_to_g: each_to_g,
      raw_to_cooked: raw_to_cooked
    }

    %Conversion{} |> Conversion.changeset(changeset) |> Repo.insert!
  end
  def insert_conversion(food_price_id, each_to_g, raw_to_cooked), do: nil


  def get_conversion_params(food_price, data) do
    %{
      food_price_id: food_price.id,
      each_to_g: data.each_to_g,
      raw_to_cooked: data.raw_to_cooked,
    }
  end

  def convert_value(_key, value) when value == "", do: nil
  def convert_value(key, value) when key in @integers do 
    {num, _} = Integer.parse(value)
    num
  end
  def convert_value(key, value) when key in @floats do 
    {num, _} = Float.parse(value)
    num
  end
  def convert_value(_key, value), do: value
end




Import.import_from_csv("foods-abridged.csv", &Seeds.Food.process_row/1)
Import.import_from_csv("prices.csv", &Seeds.Price.process_price/1)




