defmodule Kai.SolverWorkerTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.SolverWorker

  def test_file(constraints) do
    headers = Map.keys(constraints)
    
    constraints
    |> List.wrap 
    |> CSV.encode(headers: headers)
    |> Enum.reduce("", fn(line, acc) -> acc <> line end)
  end


  test "constraints written to file " do
    constraints = build(:constraints)  

    file_path = SolverWorker.write_constraints(constraints)
    expected_file = test_file(constraints)
   
    assert(file_path)
    case File.read(file_path) do
      {:ok, body} -> assert(body == expected_file)
      {:error, reason} -> flunk("no file!")
    end

    File.rm(file_path)
  end

end
