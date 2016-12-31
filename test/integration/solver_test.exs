defmodule Kai.SolverIntegrationTest do
  use Kai.IntegrationCase, async: true
  import Kai.Factory
  alias Kai.SolverWorker

  @tag external: true
  test "executes julia solver and recieves results" do
    constraints = build(:constraints)  
    {solution, levels} = SolverWorker.perform(constraints: constraints)
    
    assert is_list(solution)
    assert is_list(levels)
    assert length(solution) > 0

  end
end


