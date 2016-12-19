defmodule Kai.SolverWorker do 
  use Toniq.Worker
  import Porcelain
  import CSV

  alias Porcelain.Process
  alias Porcelain.Result

  def perform(constraints) do
    file_path = write_constraints(constraints)
   
    result = Porcelain.exec("julia", ["web/workers/glue.jl", file_path])

    IO.inspect "result"
    IO.inspect result



  end

  def write_constraints(constraints) do
    headers = Map.keys(constraints)
    file_name = "constraints.csv"
    
    file = 
      __DIR__
      |> Path.join(file_name)
      |> File.open!([:write, :utf8])
    
    constraints
    |> List.wrap 
    |> CSV.encode(headers: headers)
    |> Enum.each(&IO.write(file, &1))

    file_name
  end





end

# alternative implementation is pass constraints and foods as JSON in STDIN

