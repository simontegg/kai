defmodule Kai.SolverWorkerTest do
  use Kai.IntegrationCase, async: true
  import Kai.Factory
  alias Kai.SolverWorker


  test "executes julia solver and recieves results" do
    constraints = build(:constraints)  
    {solution, levels} = SolverWorker.perform(constraints: constraints)

    IO.inspect solution
    IO.inspect levels
    
    assert is_list(solution.foods)
    assert is_list(solution.quantities)
    assert is_list(solution.calories)
    assert is_list(solution.prices)

    assert is_list(levels.nutrient)
    assert is_list(levels.total)
    assert is_list(levels.level)

  end
end


