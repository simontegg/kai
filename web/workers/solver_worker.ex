defmodule Kai.SolverWorker do 
  use Toniq.Worker
  import Porcelain
  import CSV
  import Ecto.Query

  alias Porcelain.{Process, Result}
  alias Kai.{FoodsPrices, Price, Repo, Requirements}


  def perform(user_id: user_id) do
    #get user
    #construct constraints
    #get prices 
    #get foods associated with prices


  end



  def perform(constraints: constraints) do
    foods_prices = Repo.all(from(Price, preload: :foods))
    #file_path = write_input(constraints)

    IO.inspect foods_prices   
    #result = Porcelain.exec("julia", ["web/workers/glue.jl", file_path])




  end

  def write_input(constraints) do
    headers = Map.keys(constraints)
    file_path = Path.join(__DIR__, "constraints.csv")
    file = File.open!(file_path, [:write, :utf8])
    
    constraints
    |> List.wrap 
    |> CSV.encode(headers: headers)
    |> Enum.each(&IO.write(file, &1))

    file_path
  end

    




end

# alternative implementation is pass constraints and foods as JSON in STDIN

