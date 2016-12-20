defmodule Kai.SolverWorker do 
  use Toniq.Worker
  import Porcelain
  import CSV

  alias Porcelain.Process
  alias Porcelain.Result

  def perform(user_id: user_id) do


  end



  def perform(constraints: constraints, foods: foods) do
    file_path = write_input(constraints)
   
    result = Porcelain.exec("julia", ["web/workers/glue.jl", file_path])

    IO.inspect "result"
    IO.inspect result



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

