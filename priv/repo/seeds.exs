defmodule Seeds.Food do
  alias Kai.{NutrientNameMap, Food, Repo} 

  @nzff NutrientNameMap.nzff
  @multiplier NutrientNameMap.nzff_conversion
  @fields Map.keys(@nzff)
  @non_numeric ["Food Name", "FoodID", "Chapter"]
  
  @doc "Imports nz foodfiles data to seed the database"
  def import_from_tsv(tsv_path) do
    tsv_path
    |> Path.expand
    |> File.stream!
    |> CSV.decode(separator: ?~, headers: true)
    |> Stream.each(fn row -> 
        params = for {k, v} <- row,
          (Enum.member?(@fields, k)),
          into: %{}, 
          do: {Map.get(@nzff, k), convert_value(k, v)}
        
        food = Food.changeset(%Food{}, params)
        Repo.insert!(food)
        IO.inspect food.changes.name
      end)
    |> Stream.run
  end

  def row_to_params(row) do


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

Seeds.Food.import_from_tsv("foods-abridged.csv")




