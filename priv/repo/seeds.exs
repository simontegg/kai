defmodule Seeds.Food do

  @doc "Imports nz foodfiles data to seed the database"
  def import_from_tsv(tsv_path) do

    File.stream!(Path.expand(tsv_path))
    |> CSV.decode(separator: ?~, headers: true)
    |> Stream.each(&IO.inspect(&1))
    |> Stream.run
  end

end

#Seeds.Food.import_from_tsv('./staples.csv')
File.stream!(Path.expand("./foods.csv"))
#|> Stream.drop(1)
|> CSV.decode(separator: ?~, headers: true)
|> Stream.each(&IO.inspect(&1))
|> Stream.run


