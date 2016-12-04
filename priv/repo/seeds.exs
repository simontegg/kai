# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kai.Repo.insert!(%Kai.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
#
defmodule Seeds.Food do

  @doc "Imports nz foodfiles data to seed the database"
  def import_from_tsv(tsv_path) do

    File.stream!(Path.expand(tsv_path))
    |> CSV.decode(separator: ?~, headers: true)
    |> Stream.each(&IO.inspect(&1))
    |> Stream.run
  end

end

Seeds.Food.import_from_tsv('./staples.csv')


