defmodule Seeds.Food do
  alias Kai.NutrientNameMap 

  @nzff NutrientNameMap.nzff
  @multiplier NutrientNameMap.nzff_conversion
  @fields Map.keys(@nzff)
  
  @doc "Imports nz foodfiles data to seed the database"
  def import_from_tsv(tsv_path) do
    tsv_path
    |> Path.expand
    |> File.stream!
    |> CSV.decode(separator: ?~, headers: true)
    |> Stream.each(fn row -> 
      food = for {k, v} <- row,
        (Enum.member?(@fields, k)),
        into: %{}, 
        do: {Map.get(@nzff, k), convert_value(k, v)}
                

        IO.inspect food
    end)
    |> Stream.run
  end

  def to_number(str) do
    num = case str =~ "." do
      true  -> Float.parse(str)
      false -> Integer.parse(str)
    end

    case num do
     :error   -> :error
     {num, _} -> num
    end
  end

  def convert_value(_field, value) when value == "", do: 0
  def convert_value(field, value) when field == "Food Name", do: value
  def convert_value(field, value) do
    case Map.get(@multiplier, field) do
      nil -> to_number(value)
      m   -> to_number(value) * m
    end
  end

end

Seeds.Food.import_from_tsv("foods-abridged.csv")




