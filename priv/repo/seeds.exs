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

defmodule Seeds.Nutrition do
  alias Kai.{NutrientNameMap, Nutrition, Repo} 

  @nzff NutrientNameMap.nzff
  @multiplier NutrientNameMap.nzff_conversion
  @fields Map.keys(@nzff)
  @non_numeric ["Food Name", "FoodID", "Chapter"]

  def process_row(row) do
    params = for {k, v} <- row,
      (Enum.member?(@fields, k)),
      into: %{}, 
      do: {Map.get(@nzff, k), convert_value(k, v)}

    %Nutrition{}
    |> Nutrition.changeset(params)
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
  alias Kai.{Food, Nutrition, NutritionPrice, Price, Repo} 
  
  @integers ["price", "quantity", "each_g"]
  @floats ["raw_to_cooked"]

  def process_price(row) do
    row_data = for {k, v} <- row,
      into: %{},
      do: {String.to_atom(k), convert_value(k, v)}

    nutrition = Repo.get_by(Nutrition, name: row_data.food_name)
    price = %Price{} |> Price.changeset(row_data) |> Repo.insert!

    nutrition_price_changeset = %{nutrition_id: nutrition.id, price_id: price.id}
   
    if (row_data.each_g || row_data.raw_to_cooked) do
      food = 
        %Food{} 
        |> Food.changeset(row_data) 
        |> Repo.insert!

      nutrition_price_changeset 
      |> Map.put_new(:food_id, food.id)
      |> insert_nutrition_price
    else
      insert_nutrition_price(nutrition_price_changeset)
    end
  end

  def insert_nutrition_price(changeset) do 
    %NutritionPrice{} |> NutritionPrice.changeset(changeset) |> Repo.insert!
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

Import.import_from_csv("foods-abridged.csv", &Seeds.Nutrition.process_row/1)
Import.import_from_csv("prices.csv", &Seeds.Price.process_price/1)




