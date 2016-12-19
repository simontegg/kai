defmodule Kai.SolverWorkerTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.SolverWorker

  test "constraints written to file " do
    constraints = build(:constraints)  

    file_path = SolverWorker.write_constraints(constraints)
    expected_file = "" 
    
    case File.read!(file_path) do
      {:ok, body} -> assert(body == expected_file)
      {:error, reason} -> flunk("no file!")
    end
  end

end
