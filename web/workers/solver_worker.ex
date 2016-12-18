defmodule Kai.SolverWorker do 
  use Toniq.Worker
  import Porcelain
  import CSV

  alias Porcelain.Process
  alias Porcelain.Result

  def perform(intake) do
    headers = Map.keys(intake)
    
    file = 
      __DIR__
      |> Path.join("intake.csv")
      |> File.open!([:write, :utf8])
    
    intake_csv = 
      intake 
      |> List.wrap 
      |> CSV.encode(headers: headers)
      |> Enum.each(&IO.write(file, &1))

    


    

    result = Porcelain.shell("julia solver/glue.jl #{intake_csv}")

    IO.inspect result.out



    #   options = [in: :receive, out: {:send, self()}]
    #   solver = %Process{pid: pid} = 
    #     Porcelain.spawn_shell("julia solver/glue.jl", in: :receive, out: {:send, self()})

    #   Process.send_input(solver, "abc")
    #   receive do
    #     {^pid, :data, :out, data} -> IO.inspect data
    #   end
  end

end


